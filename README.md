# opusreader2

<!-- badges: start -->
[![tic](https://github.com/spectral-cockpit/opusreader2/workflows/tic/badge.svg?branch=main)](https://github.com/spectral-cockpit/opusreader2/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
<!-- badges: end -->


## Scope

This is an universal OPUS binary reader for R. It parses the file header for assigning
spectral blocks.

This package has grown out of {opusreader} made by Pierre Roudier and Philipp
Baumann. {opusreader} works, but not for all OPUS files. It implements a reverse
engineered logic, that assigns byte offsets to read different data blocks in the
OPUS binary file. This is not 100% robust and causes some read failures in edge
cases.

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
