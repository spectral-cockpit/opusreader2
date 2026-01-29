## 29-01-2026 Submission, version 0.6.8
This is a resubmission. There were 2 pre-tests NOTES, which I fixed where
applicable.

  * Possibly misspelled words in `DESCRIPTION`: Bruker (2:37, 22:34),
    GmbH (22:48), chemometrics (29:32). The first word is the company name.
    I have now added a disclaimer. "This package is released independently from
    Bruker, and Bruker and OPUS are registered trademarks of Bruker Optics GmbH
    & Co. KG.". The third word, "chemometrics", is a well-established term.
    https://cran.r-project.org/web/views/ChemPhys.html .
  * I have fixed the non-standard file/directory NOTE for `./jarl.toml`, which
    occured because I did not correctly ignore `jarl` linter configuration that
    I added in the resubmission of version 0.6.7.

R CMD check using R-devel with win-builder:

```
New submission
Status: 1 NOTE

New submission

Possibly misspelled words in DESCRIPTION:
  Bruker (2:37, 21:30, 22:43, 23:49, 23:61, 24:30)
  GmbH (22:57, 24:44)
  chemometrics (31:32)
```

These are not misspellings.

## 28-01-2026 Resubmission, version 0.6.7
This is a resubmission. In this version I have:

* Addressed feedback from the initial CRAN submission review:
  * Hydrated the Description field, i.e. added details about what the package
    does and how it is useful. I further added a reference URL to the Bruker
    OPUS software producing the Bruker OPUS binary files.
  * Added return values for the exported methods `print.list_opusreader2()`
    and `read_opus_single()`.

## R CMD check results

0 errors ✔ | 0 warnings ✔ | 0 notes ✔
