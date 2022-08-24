# opusreader2

<!-- badges: start -->
[![tic](https://github.com/spectral-cockpit/opusreader2/workflows/tic/badge.svg?branch=main)](https://github.com/spectral-cockpit/opusreader2/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
<!-- badges: end -->


## Scope

Read OPUS binary files from Fourier-Transform Infrared (FT-IR) spectrometers of
the company Bruker Optics GmbH & Co. in R.

## Installation

The current version version can be installed with.

```
if (!require("remotes")) install.packages("remotes")
remotes::install_github("spectral-cockpit/opusreader2")
```

## Example

```
library("opusreader2")
# read a single file (one measurement)
file <- opus_file()
data_list <- read_opus_file(file)
```

## Background

This package is a major rework of {opusreader} made by Pierre Roudier and
Philipp Baumann. {opusreader} works, but not for all OPUS files. This precessor
package relies on an interesting but not optimal reverse engineered logic.
Particularly, the assignment of spectral data types (i.e., single channel
reflectance vs. final result spectrum), was buggy because the CO2 peak ratio was
used as a heuristic. Also, byte offsets from three letter strings were directly
used to read specific data and assign block types. This is not 100% robust and
causes some read failures in edge cases.

The new package parses the file header for assigning spectral blocks.

## Credits

- Pierre Roudier and Philipp Baumann made an improved R reader, further
  developing the version in simplerspec.
  https://github.com/pierreroudier/opusreader
- QED.ai: implemented a python parser which takes the main the logic of
  ono.
  https://github.com/qedsoftware/brukeropusreader
- twagner: wrote a OPUS FTIR clone called ono. Original decrypter of the header.
  https://pypi.org/project/ono/
- Andrew Sila and Tomislav Hengl: wrote a first OPUS reader in R.
  https://github.com/cran/soil.spec/blob/master/R/read.opus.R
