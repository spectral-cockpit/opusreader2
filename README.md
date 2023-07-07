# opusreader2

<!-- badges: start -->
[![tic](https://github.com/spectral-cockpit/opusreader2/workflows/tic/badge.svg?branch=main)](https://github.com/spectral-cockpit/opusreader2/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
![runiverse-package opusreader2](https://spectral-cockpit.r-universe.dev/badges/opusreader2?scale=1.25&color=pink&style=flat)
<!-- badges: end -->

<p align="right"; style="font-size:11px"> <a href="https://www.instagram.com/lilyanblazoudaki">Artwork by Lilyan Blazoudaki</a></p>
<img align="right" width="250" src="man/figures/logo.png">

## 🪄 Scope

*"grab 'em all"* --- Read OPUS binary files from Fourier-Transform Infrared (FT-IR) spectrometers of
the company Bruker Optics GmbH & Co. in R.

## 🪩 Highlights and disclaimer

The [Bruker corporation](https://www.bruker.com/en.html) manufactures reliable instruments but there is no official documentation of the OPUS file format. Hence the format is proprietary. Luckily, we and our colleagues from the open source spectroscopy community have cracked it. With some heavy lifting we have unscrambled the file logic (see credits).

{opusreader2} is a state-of-the-art binary reader. We recommend the package as a solid foundation for your spectroscopy workflow. It is modular and has no hard dependencies apart from base R. By providing feedback, opening and solving issues, or making pull requests, you can actively contribute to the spectroscopy communities. These efforts are mainly to support more and more instruments, measurement modes, and block types. You can also soon rely on our ready-made diagnostic solutions building upon it. If you wish, the [spectral-cockpit team](https://github.com/spectral-cockpit) further offers consulting service along your entire spectroscopy workflow. 

We have reached stable package development now. The core API of `opusreader2::read_opus()` is solid and we are not planning any major user-facing design changes. There will be extended capabilities after basic reading in additional functions downstream. For example, to exact specific parts of interest like measurement metadata or to accomplish read workflows for custom environments.

Our current development efforts are

1. improving the ease of use (documentation, vignettes)
2. expanding support for Bruker data blocks even further 
3. providing useful downstream features for metadata and spectra management (additional helper and wrapper functions). 

We now track changes under semantic versioning using [{fledge}](https://github.com/cynkra/fledge). Please consult the [NEWS](NEWS.md) to follow progress and history of features along semantic versioning.
Our goal is to release a stable version on CRAN that is production ready very soon. Expected time of arrival is July 2023.

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

<details>
<summary>Reading files in parallel [expand]
</summary>

Multiple OPUS files can optionally be read in parallel using the {future}
framework. For this, parallel workers need to be registered.

```r
file <- opus_file()
files_1000 <- rep(file, 1000L)

if (!require("future")) install.packages("future")
if (!require("future.apply")) install.packages("future.apply")

# register parallel backend (multisession; using sockets)
future::plan(future::multisession)

data <- read_opus(dsn = files_1000, parallel = TRUE)
```
</details>


<details>
<summary>Reading files in parallel with progress updates [expand]
</summary>

If `parallel = TRUE`, progress updates via {progressr} are optionally available

```r
if (!require("progressr")) install.packages("progressr")
library("progressr")

future::plan(future::multisession)

handlers(global = TRUE)
handlers("progress") # base R progress animation

file <- opus_file()
files_1000 <- rep(file, 1000L)

# read with progress bar
data <- read_opus(dsn = files_1000, parallel = TRUE, progress_bar = TRUE)
```

Optionally, the number of desired chunks can be specified via options.

```r
options(number_of_chunks = 20L)
data <- read_opus(dsn = files_1000, parallel = TRUE, progress_bar = TRUE)
```
</details>


<details>
<summary> Read a single OPUS file [expand]
</summary>

```r
data <- read_opus_single(dsn = file)
```
</details>



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
