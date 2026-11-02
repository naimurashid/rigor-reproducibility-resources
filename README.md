# Rigor and Reproducibility - Resources

Companion materials for the talk *Rigor and Reproducibility* by [Naim Rashid, PhD](https://naimurashid.github.io) (UNC Chapel Hill) for UNC Lineberger T32 trainees. The talk is at [rashidlab.github.io/talks/2027-tbd-lineberger-t32-rigor-reproducibility-deck/t32-rigor-reproducibility.html](https://rashidlab.github.io/talks/2027-tbd-lineberger-t32-rigor-reproducibility-deck/t32-rigor-reproducibility.html). This repository holds the files behind the four things you hand to an analyst (raw data, a tidy table, a codebook and a recipe), plus a short example of a rerunnable report. You do not need to program to use the checklist and the codebook. Everything is free to download and adapt.

## Slide-to-file map

If you photographed slide N and want the digital version:

| Slide | Topic | File |
|---|---|---|
| 15 | Four things, every time | [`handoff-checklist.md`](handoff-checklist.md) |
| 16 | The raw data stays raw | [`handoff-checklist.md`](handoff-checklist.md), block 1 |
| 17 | One row per observation | [`examples/tidy-sheet.csv`](examples/tidy-sheet.csv) |
| 18 | What is wrong with this sheet? | [`examples/messy-sheet.xlsx`](examples/messy-sheet.xlsx) |
| 19 | Rules for the sheet you type into | [`handoff-checklist.md`](handoff-checklist.md), block 2, and Broman and Woo in [`links.md`](links.md) |
| 20 | The codebook | [`codebook-template.csv`](codebook-template.csv) and [`codebook-template.md`](codebook-template.md) |
| 21 | The recipe | [`examples/recipe.R`](examples/recipe.R) and [`examples/recipe.py`](examples/recipe.py) |
| 22 | Your DMS plan | [`handoff-checklist.md`](handoff-checklist.md) and [`links.md`](links.md) |
| 23 | Bring the analyst in early | [`links.md`](links.md), UNC Lineberger section |
| 27 | The figures come out of the code | [`examples/report.qmd`](examples/report.qmd) |
| 28 | Version control and a DOI | [`links.md`](links.md), Tools section |
| 38 | Reproducible can still be wrong | [`links.md`](links.md), NIGMS modules |
| 41 | Resources | [`links.md`](links.md) |

## How to use each file

**Handoff checklist.** Print it or copy it into your notebook. Work through the five blocks before you send data to a core, a labmate or a collaborator.

**Codebook template.** Copy the CSV, delete the six example rows (from a mouse tumor-volume study), and write one row per column of your own table. The Markdown file has the same content with a short note on how to fill it in.

**Examples.** `messy-sheet.xlsx` is the exercise sheet from slide 18, and `tidy-sheet.csv` is what it should look like after cleaning. A recipe is a script that turns the first into the second and records every decision, so nothing is done by hand. `recipe.R` uses R with the data.table, readxl and openxlsx packages, and `recipe.py` uses Python with pandas and openpyxl. Run either from the top folder of this repository, for example `Rscript examples/recipe.R` or `python examples/recipe.py`. Both read the messy sheet and rewrite `tidy-sheet.csv`.

**Report.** `examples/report.qmd` is a Quarto document (a file mixing text and code that rebuilds its own figure and table). Run `quarto render examples/report.qmd` after the recipe to get an HTML page. Delete the HTML and render again to check that you get the same result.

**Links.** Policy pages, training, teaching resources, and where to find the Lineberger Biostatistics and Bioinformatics cores.

## License

[CC BY 4.0](LICENSE). Use and adapt freely, with credit.
