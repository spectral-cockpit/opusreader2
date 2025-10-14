# opusreader2

<!-- badges: start -->
[![tic](https://github.com/spectral-cockpit/opusreader2/workflows/tic/badge.svg?branch=main)](https://github.com/spectral-cockpit/opusreader2/actions)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![runiverse-package opusreader2](https://spectral-cockpit.r-universe.dev/badges/opusreader2?scale=1&color=pink&style=round)](https://spectral-cockpit.r-universe.dev/opusreader2)
<!-- badges: end -->

<p align="right"; style="font-size:11px"> <a href="https://www.instagram.com/lilyanblazoudaki">Artwork by Lilyan Blazoudaki</a></p>
<img align="right" width="250" src="man/figures/logo.png">

## 🪄 Scope

*grab 'em all* — Read OPUS binary files from Fourier-Transform Infrared (FT-IR) spectrometers manufactured by Bruker Optics GmbH & Co. directly in R.
This package is developed openly in our spare time, so there is no guarantee of support.
If you would like a new feature implemented or encounter something you need urgently, we offer development under a standard IT contract at an hourly rate.
To help cover our coffee expenses, we appreciate any donations.

[!["Buy spectral-cockpit.space some beers"](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/specphil)

## 🪩 Highlights and disclaimer

The [Bruker corporation](https://www.bruker.com/en.html) produces reliable instruments; however, there is no official documentation for the OPUS file format, making it proprietary.
Fortunately, our team and colleagues from the open-source spectroscopy community have successfully deciphered it. With considerable effort, we've unraveled the file logic (see credits).

{opusreader2} stands as a state-of-the-art binary reader, serving as a robust foundation for your spectroscopy workflow.
Notably modular, it imposes no hard dependencies beyond base R.
Actively contributing to the spectroscopy communities is encouraged through feedback, issue reports, and pull requests.
These collective efforts aim to enhance support for a growing array of instruments, measurement modes, and block types.
Additionally, be on the lookout for our forthcoming diagnostic solutions built upon {opusreader2}.
For those seeking personalized assistance, Spectral-Cockpit offers consulting services tailored to every stage of your spectroscopy workflow.

We have now achieved stability in package development.
The core API of `opusreader2::read_opus()` is robust, and we do not anticipate any significant user-facing design changes.
Moving forward, additional functions downstream will extend the capabilities, allowing users to extract specific areas of interest, such as measurement metadata, or to facilitate reading workflows for custom environments.

Our current development efforts are

1.  expanding support for Bruker data blocks even further
2.  providing useful downstream features for metadata and spectra management through additional helper and wrapper functions.

We have adopted semantic versioning with [{fledge}](https://github.com/cynkra/fledge) to track changes.
To stay updated on the progress and history of features aligned with semantic versioning, please refer to the [NEWS](NEWS.md).
Our aim is to soon release a stable version on CRAN that is production-ready. The expected time of arrival is January 2024.

## 📦 Installation

The latest version can be installed

<details>

<summary>directly via <a href="https://spectral-cockpit.r-universe.dev/ui#package:opusreader2">R-universe</a> [expand]</summary>

``` r
# Install the latest version
install.packages("opusreader2", repos = c(
  spectralcockpit = 'https://spectral-cockpit.r-universe.dev',
  CRAN = 'https://cloud.r-project.org'))
```

</details>

<details>

<summary>from CodeFloe.com via {remotes} [expand]</summary>

``` r
if (!require("remotes")) install.packages("remotes")
remotes::install_git("https://codefloe.com/philipp-baumann/opusreader2")
```

</details>

## 🔦 Examples

We recommend to start with the vignette [*"Reading OPUS binary files from Bruker® spectrometers in R"*](https://spectral-cockpit.github.io/opusreader2/articles/opusreader2_introduction.html).

``` r
library("opusreader2")
# read a single file (one measurement)
file <- opus_test_file()
data <- read_opus(dsn = file)
```

<details>

<summary>Reading files in parallel [expand]</summary>

Multiple OPUS files can optionally be read in parallel using the {mirai} backend.
For this, parallel workers need to be registered.

``` r
files_1000 <- rep(file, 10000L)

if (!require("mirai")) install.packages("mirai")

library("mirai")
daemons(n = 2L, dispatcher = TRUE)

data <- read_opus(dsn = files_1000, parallel = TRUE)
```

</details>

<details>

<summary>Reading files in parallel with progress updates [expand]</summary>

If `parallel = TRUE`, progress updates via {progressr} are optionally available

``` r
if (!require("progressr")) install.packages("progressr")
library("progressr")

handlers(global = TRUE)
handlers("progress") # base R progress animation

file <- opus_test_file()
files_1000 <- rep(file, 1000L)

# read with progress bar
data <- read_opus(dsn = files_1000, parallel = TRUE, progress_bar = TRUE)
```

Optionally, the number of desired chunks can be specified via options.

``` r
options(number_of_chunks = 20L)
data <- read_opus(dsn = files_1000, parallel = TRUE, progress_bar = TRUE)
```

</details>

<details>

<summary>Read a single OPUS file [expand]</summary>

``` r
data <- read_opus_single(dsn = file)
```

</details>

## Advanced testing and Bruker OPUS file specification

We strive to have a full-fledged reader of OPUS files that is on par with the commercial reader in the Bruker OPUS software suite.

To contribute to the development, we will provide an additional vignette that describes the OPUS format and the technical details of our implementation in the package.

## How to contribute

We like the spirit of open source development, so any constructive suggestions or questions are always welcome.
To trade off the consistency and quality of code with the drive for innovation, we are following some best practices (which can be indeed improved, as many other things in life). These are:

-   **Code checks (linting), styling, and spell checking**: We use the [pre-commit](https://pre-commit.com/) framework with both some generic coding and R specific hooks configured in [`.pre-commit-config.yaml`](.pre-commit-config.yaml).
Generally, we follow the tidyverse style guide, with slight exceptions. To provide auto-fixing in PRs where possible, we rely on [pre-commit.ci lite](https://pre-commit.ci/lite.html).

<details>

<summary>Install and enable pre-commit hooks locally (details)</summary>

1.  install pre-commit with python3. For more details and options, see [the official documentation](https://pre-commit.com/)

``` sh
# in terminal
pip3 install pre-commit --user
```

2.  enable the pre-commit hooks in `.pre-commit-config.yaml`

``` sh
# change to cloned git directory of your fork of the package
pre-commit install
```

Once you do a `git commit -m "<your-commit-message>"`, the defined pre-commit hooks will automatically be applied on new commits.

</details>

<details>

<summary>Check all files for which pre-commit hooks are configured (details)</summary>

``` sh
# in your terminal and package root directory
pre-commit run --all-files
```

</details>

## Organizations and projects using {opusreader2}

As far as we know, the following organizations and projects use our package.
Please make a pull request if you want to be listed here.

-   CSIRO
-   Open Soil Spectral Library
-   ETH Zürich: Sustainable Agroecosystems group and Soil Resources group

## Background

This package is a major rework of {opusreader} made by Pierre Roudier and Philipp Baumann. 
{opusreader} works, but not for all OPUS files.
This precessor package relies on an interesting but not optimal reverse engineered logic.
Particularly, the assignment of spectral data types (i.e., single channel reflectance vs. final result spectrum), was buggy because the CO2 peak ratio was used as a heuristic.
Also, byte offsets from three letter strings were directly used to read specific data and assign block types.
This is not 100% robust and causes some read failures in edge cases.

The new package parses the file header for assigning spectral blocks.

## Credits

-   Pierre Roudier and Philipp Baumann made an improved R reader, further developing the [version in simplerspec](https://github.com/philipp-baumann/simplerspec/blob/master/R/read-opus-universal.R) by Philipp. <https://github.com/pierreroudier/opusreader>
-   QED.ai: implemented a python parser which takes the main the logic of ono. <https://github.com/qedsoftware/brukeropusreader>
-   twagner: wrote a OPUS FTIR clone called ono. Original decrypter of the header. <https://pypi.org/project/ono/>
-   Andrew Sila and Tomislav Hengl: wrote a first OPUS reader in R. <https://github.com/cran/soil.spec/blob/master/R/read.opus.R>
