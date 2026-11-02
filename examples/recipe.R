# recipe.R: raw to tidy with nothing done by hand.
# Reads examples/messy-sheet.xlsx (never edited) and writes examples/tidy-sheet.csv.
# Run from the top folder of the repository: Rscript examples/recipe.R
# Needs data.table, readxl, and openxlsx (openxlsx is used only to read cell colours).
library(data.table); library(readxl); library(openxlsx)
raw_file <- "examples/messy-sheet.xlsx"; out_file <- "examples/tidy-sheet.csv"
EXCLUDE_FILL <- "FFFFE699"   # yellow in the Mouse column means "excluded" (the sheet has no legend)
STUDY_YEAR   <- 2025         # "March 4" has no year, so we assume the study year and say so here

# 1. Merged headers: skip the two header rows and name the columns ourselves.
x <- as.data.table(read_excel(raw_file, col_names = FALSE, col_types = "text", skip = 2, .name_repair = "minimal"))
setnames(x, c("mouse_id", "group", "date_day0", "d0", "d7", "d14", "marker_gene", "note"))
x[, xl_row := .I + 2]                       # row number in the spreadsheet

# 2. Totals row in the middle of the data ("Mean"): drop it.
x <- x[!grepl("^(mean|total)", mouse_id, ignore.case = TRUE)]

# 3. Colour-coded exclusions: a yellow Mouse cell means excluded. The reason is the note beside it.
wb <- loadWorkbook(raw_file); yellow <- integer(0)
for (s in wb$styleObjects) if (any(grepl(EXCLUDE_FILL, unlist(s$style$fill)))) yellow <- c(yellow, s$rows[s$cols == 1])
x[, excluded := xl_row %in% yellow]

# 4. Three date formats ("3/4/25", "2025-03-04", "March 4") become one ISO date.
parse_date <- function(s) {
  for (f in c("%Y-%m-%d", "%m/%d/%y", "%B %d %Y")) { d <- as.Date(if (f == "%B %d %Y") paste(s, STUDY_YEAR) else s, f); if (!is.na(d)) return(d) }
  as.Date(NA) }
x[, date_day0 := as.Date(sapply(date_day0, parse_date), origin = "1970-01-01")]

# 5. A gene name Excel turned into a date (SEPT2 became 2-Sep, stored as day number 45902).
is_serial <- grepl("^[0-9]{5}$", x$marker_gene)
d <- as.Date(as.numeric(x$marker_gene[is_serial]), origin = "1899-12-30")
x[is_serial, marker_gene := paste0(toupper(format(d, "%b")), as.integer(format(d, "%d")))]
x[marker_gene == "SEP2", marker_gene := "SEPT2"]   # Excel's abbreviation is SEP, the gene is SEPT2

# 6. Wide to long: one row per mouse per day. Units sit inside the cells ("12.3 mm3"), so strip them.
long <- melt(x, id.vars = c("mouse_id", "group", "date_day0", "marker_gene", "excluded", "note"),
             measure.vars = c("d0", "d7", "d14"), variable.name = "day", value.name = "tumor_volume_mm3")
long[, day := as.integer(sub("d", "", day))]
long[, tumor_volume_mm3 := as.numeric(sub("\\s*mm3$", "", tumor_volume_mm3))]

# 7. Blanks mean different things. We only label what the sheet itself supports.
long[, missing_reason := fifelse(!is.na(tumor_volume_mm3), NA_character_,
  fifelse(grepl("dead|died", note) & day > max(c(-1, day[!is.na(tumor_volume_mm3)])), "died", "blank_reason_unknown")), by = mouse_id]

setorder(long, mouse_id, day)
fwrite(long[, .(mouse_id, group, date_day0, day, tumor_volume_mm3, marker_gene, excluded, missing_reason, note)], out_file)
cat("Wrote", nrow(long), "rows to", out_file, "\n")
