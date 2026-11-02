# Handoff checklist

Use this when you give data to a statistician, a core, a labmate, or your own future self. Tick each box. The four things are raw data, a tidy table, a codebook and a recipe.

## 1. Raw data

- [ ] **The original files are saved exactly as the instrument, REDCap export or plate reader produced them.** The analyst needs the untouched source to check any later step.
- [ ] **They sit in a read-only folder, apart from everything you edit.** This stops an accidental overwrite.
- [ ] **Nothing is summarized, renamed inside the file, or deleted.** A deleted row cannot be defended later.
- [ ] **For sequencing or large files, a checksum is saved beside each file.** A checksum is a short fingerprint of a file, so anyone can confirm that their copy is identical.

## 2. Tidy table

- [ ] **One row per observation and one column per variable.** Statistical software expects this shape, and a wide sheet with one column per time point does not fit it.
- [ ] **One header row, with no merged cells.** Merged cells break when the file is read by a program.
- [ ] **No color or bold used to carry meaning.** A program cannot see color, so use a column such as `excluded`.
- [ ] **Dates are written YYYY-MM-DD and units are in the column name.** This avoids three date formats and numbers like "12 mm" in a cell.
- [ ] **Saved as a CSV (a plain text table) as well as xlsx.** A CSV opens everywhere and cannot hide formulas.

## 3. Codebook

- [ ] **Every column has a row giving its description, type, units and allowed values.** The analyst cannot guess what "vol2" means.
- [ ] **The code for a missing value is written down once.** A blank, 0, 999 and NA can mean different things.
- [ ] **Design quirks are noted, such as batch, plate, cage and date of any protocol change.** These often explain differences that look like biology.

## 4. Recipe

- [ ] **A script or written list of steps takes you from the raw data to the tidy table.** Anyone can then repeat it and get the same table.
- [ ] **Every exclusion is in the recipe with the reason it was made.** Exclusions remembered only in your head cannot be checked.
- [ ] **You deleted the tidy table once and rebuilt it from the recipe.** This is the test that it works.

## 5. Before you send it

- [ ] The folder opens on another computer and the file names make sense without you.
- [ ] No patient identifiers are in anything you send, and you know where the identified version is stored.
- [ ] Every figure in your draft can be traced to a file and a step in the recipe.
- [ ] The README or first lines of the recipe say who to ask, the date, and the software versions used.
- [ ] You told the analyst the question you are trying to answer and how many animals or samples you planned at the start.
