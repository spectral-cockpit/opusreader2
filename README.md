# opusreader2

<!-- badges: start -->
[![tic](https://github.com/spectral-cockpit/opusreader2/workflows/tic/badge.svg?branch=main)](https://github.com/spectral-cockpit/opusreader2/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
![runiverse-package opusreader2](https://spectral-cockpit.r-universe.dev/badges/opusreader2?scale=1.25&color=pink&style=flat)
<!-- badges: end -->


## 🪄 Scope

*"grab 'em all"* --- Read OPUS binary files from Fourier-Transform Infrared (FT-IR) spectrometers of
the company Bruker Optics GmbH & Co. in R.

## 🪩 Highlights and disclaimer

The Bruker corporation does not hand out any official documentation of the OPUS file format. Hence it is proprietary. Luckily we and our colleagues from the open source spectroscopy community have made our official ways around it. With some heavy lifting we have unscrambled the file logic (see credits). We from [spectral-cockpit team](https://github.com/spectral-cockpit) are happy to offer consulting and a state-of-the-art binary reader for the R community. You can help us further to support more and more instruments, measurement modes and block types. We can recommend the package as a solid foundation to your spectroscopy workflow, or you can soon rely on our custom services/infrastructure, thanks to:

We are currently at mid-development phase. The core API of `opusreader2::read_opus()` has been solidified and we are
not planning any major user-facing design changes. We plan more features in additional functions downstream. For example, to exact specific parts of interest like measurement metadata or to accomplish read workflows for custom environments. 
Currently, we focus on

1. improving the ease of use (documentation, vignettes)
2. expanding support for Bruker data blocks even further 
3. providing useful downstream features for metadata and spectra management (additional helper and wrapper functions). 

We now track changes under semantic versioning using [{fledge}](https://github.com/cynkra/fledge). Please consult the [NEWS](NEWS.md) to follow progress and history of features along semantic versioning.
Our goal is to release a stable version 1.0.0 on CRAN that is production ready, planned until End of January 2023. 

## 📦 Installation

The latest version can be installed

<details>
<summary>directly via <a href="https://spectral-cockpit.r-universe.dev/ui#package:opusreader2">R-universe</a> [expand]
</summary>

```r
# Install the latest version
install.packages("opusreader2", repos = c(
  spectralcockpit = 'https://spectral-cockpit.r-universe.dev',
  CRAN = 'https://cloud.r-project.org'))
```
</details>

<details>
<summary>from GitHub via {remotes} [expand]
</summary>

```r
if (!require("remotes")) install.packages("remotes")
remotes::install_github("spectral-cockpit/opusreader2")
```
</details>

## 🔦 Examples

```r
library("opusreader2")
# read a single file (one measurement)
file <- opus_file()
data_list <- read_opus(dsn = file)
```

## Advanced testing and Bruker OPUS file specification

We strive to have a full-fledged reader of OPUS files that is on par with
the commercial reader in the Bruker OPUS software suite.

To contribute to the development, we will provide an additional vignette
that describes the OPUS format and the technical details of our
implementation in the package.

## How to contribute

We like the spirit of open source development, so any constructive suggestions
or questions are always welcome. To trade off the consistency and quality of
code with the drive for innovation, we are following some best practices
(which can be indeed improved, as many other things in life). These are:

- **Code checks (linting), styling, and spell checking**: We use
  the [pre-commit](https://pre-commit.com/) framework with
  both some generic coding and R specific hooks configured in
  [`.pre-commit-config.yaml`](.pre-commit-config.yaml).
  Generally, we follow the tidyverse style guide, with slight exceptions. To
  provide auto-fixing in PRs where possible, we rely on
  [pre-commit.ci lite](https://pre-commit.ci/lite.html).

<details>
<summary>Install and enable pre-commit hooks locally (details)</summary>

1. install pre-commit with python3. For more details and options, see
  [the official documentation](https://pre-commit.com/)

```sh
# in terminal
pip3 install pre-commit --user
```

2. enable the pre-commit hooks in `.pre-commit-config.yaml`

```sh
# change to cloned git directory of your fork of the package
pre-commit install
```
Once you do a `git commit -m "<your-commit-message>"`, the defined pre-commit
hooks will automatically be applied on new commits.
</details>

<details>
<summary>Check all files for which pre-commit hooks are configured (details)
</summary>

```sh
# in your terminal and package root directory
pre-commit run --all-files
```

</details>

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
  developing the [version in simplerspec](https://github.com/philipp-baumann/simplerspec/blob/master/R/read-opus-universal.R) by Philipp.
  https://github.com/pierreroudier/opusreader
- QED.ai: implemented a python parser which takes the main the logic of
  ono.
  https://github.com/qedsoftware/brukeropusreader
- twagner: wrote a OPUS FTIR clone called ono. Original decrypter of the header.
  https://pypi.org/project/ono/
- Andrew Sila and Tomislav Hengl: wrote a first OPUS reader in R.
  https://github.com/cran/soil.spec/blob/master/R/read.opus.R
