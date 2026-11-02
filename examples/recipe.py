"""recipe.py: raw to tidy with nothing done by hand.
Reads examples/messy-sheet.xlsx (never edited) and writes examples/tidy-sheet.csv.
Run from the top folder of the repository: python examples/recipe.py
Needs pandas and openpyxl (openpyxl is used to read cell colours)."""
import pandas as pd
from openpyxl import load_workbook

RAW, OUT = "examples/messy-sheet.xlsx", "examples/tidy-sheet.csv"
EXCLUDE_FILL = "FFFFE699"   # yellow in the Mouse column means "excluded" (the sheet has no legend)
STUDY_YEAR = 2025           # "March 4" has no year, so we assume the study year and say so here

# 1. Merged headers: skip the two header rows and name the columns ourselves.
x = pd.read_excel(RAW, header=None, skiprows=2, dtype=str)
x.columns = ["mouse_id", "group", "date_day0", "d0", "d7", "d14", "marker_gene", "note"]
x["xl_row"] = x.index + 3                      # row number in the spreadsheet

# 2. Totals row in the middle of the data ("Mean"): drop it.
x = x[~x.mouse_id.str.match(r"(?i)^(mean|total)", na=False)].copy()

# 3. Colour-coded exclusions: a yellow Mouse cell means excluded. The reason is the note beside it.
ws = load_workbook(RAW).active
x["excluded"] = [ws.cell(row=int(r), column=1).fill.fgColor.rgb == EXCLUDE_FILL for r in x.xl_row]

# 4. Three date formats ("3/4/25", "2025-03-04", "March 4") become one ISO date.
def parse_date(s):
    for f, txt in (("%Y-%m-%d", s), ("%m/%d/%y", s), ("%B %d %Y", f"{s} {STUDY_YEAR}")):
        try: return pd.to_datetime(txt, format=f)
        except ValueError: pass
    return pd.NaT
x["date_day0"] = x.date_day0.map(parse_date)

# 5. A gene name Excel turned into a date (SEPT2 became 2-Sep, stored as a real date).
def fix_gene(s):
    if not isinstance(s, str) or not s.endswith("00:00:00"): return s   # pandas shows date cells as "2025-09-02 00:00:00"
    d = pd.Timestamp(s)
    return "SEPT" + str(d.day) if d.month == 9 else s    # Excel's abbreviation is SEP, the gene is SEPT2
x["marker_gene"] = x.marker_gene.map(fix_gene)

# 6. Wide to long: one row per mouse per day. Units sit inside the cells ("12.3 mm3"), so strip them.
ids = ["mouse_id", "group", "date_day0", "marker_gene", "excluded", "note"]
long = x.melt(id_vars=ids, value_vars=["d0", "d7", "d14"], var_name="day", value_name="tumor_volume_mm3")
long["day"] = long.day.str[1:].astype(int)
long["tumor_volume_mm3"] = pd.to_numeric(long.tumor_volume_mm3.str.replace(r"\s*mm3$", "", regex=True))

# 7. Blanks mean different things. We only label what the sheet itself supports.
long = long.sort_values(["mouse_id", "day"])
last = long.dropna(subset=["tumor_volume_mm3"]).groupby("mouse_id").day.max()
dead = long.note.str.contains("dead|died", na=False) & (long.day > long.mouse_id.map(last).fillna(-1))
long["missing_reason"] = None
blank = long.tumor_volume_mm3.isna()
long.loc[blank, "missing_reason"] = dead[blank].map({True: "died", False: "blank_reason_unknown"})

cols = ["mouse_id", "group", "date_day0", "day", "tumor_volume_mm3", "marker_gene", "excluded", "missing_reason", "note"]
long[cols].to_csv(OUT, index=False, date_format="%Y-%m-%d"); print("Wrote", len(long), "rows to", OUT)
