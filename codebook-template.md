# Codebook template

A codebook is a table that says what every column in your data means, so that someone who was not in the lab (including you in a year) can use the data without asking. The filled rows below come from an example mouse tumor-volume study. Copy [`codebook-template.csv`](codebook-template.csv), delete the example rows, and fill in one row per column of your tidy table.

| variable | description | type | units | allowed_values | missing_code | source | notes |
|---|---|---|---|---|---|---|---|
| mouse_id | Unique animal identifier assigned at ear tagging | text | | M001 to M120 | none allowed | cage card | Never reused after an animal is removed |
| treatment | Treatment arm the mouse was randomized to | category | | vehicle, drug_low, drug_high | none allowed | randomization sheet | Blinded labels A B C were decoded on 2026-04-15 |
| implant_date | Date tumor cells were implanted | date | YYYY-MM-DD | 2026-01-01 to 2026-12-31 | none allowed | lab notebook p. 41 | Same date for all mice in a cage |
| tumor_volume_mm3 | Tumor volume from caliper length and width | number | mm3 | 0 to 3000 | NA | caliper sheet | Volume = length x width x width / 2, measured twice weekly by the same person |
| body_weight_g | Body weight at the time of the tumor measurement | number | g | 10 to 40 | NA | balance printout | NA means the mouse was not weighed that day |
| excluded | Whether the mouse is left out of the analysis | logical | | TRUE, FALSE | none allowed | study log | Every TRUE row needs a reason in exclusion_reason |

## How to fill this in

Write one row for every column in the tidy table, using the same name as the column header. The description should say what was measured and how, in a sentence a stranger could follow. Type is one of text, number, date, category or logical. Put the unit in its own column and never inside the cell values. List the allowed values or range, so that an impossible value (a weight of 250 g) can be caught. Missing code says exactly how a missing value is written, and it should be one code used everywhere, because a blank can mean not measured, not applicable or lost. Source says where the value came from. Use the notes column for anything about the design that changes how the data should be read, such as batch, plate, cage, instrument, operator or date of a protocol change. Write the codebook while the experiment is running, not when the paper is being written.
