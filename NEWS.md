<!-- NEWS.md is maintained by https://cynkra.github.io/fledge, do not edit -->

# opusreader2 0.6.4 (2025-09-24)

## Features

- `read_opus()`: support "mirai" async backend. `.parallel_backend` now defaults to `"mirai"`.

## Bug fixes

- `read_opus()`: consistenly assign `opusreader2_list` class

## Chores

- `opus_lapply()`: remove from docs
- Update vignette with new "mirai" parallel interface

# opusreader2 0.6.3 (2024-03-12)

## Bug fixes

- fix sample and time metadata parsing for `read_opus(dsn, data_only = TRUE)`. 
  Previously, extraction of the timestamp failed and data extracted errored
  in that case, because there was the required `"history"` and `"sample"` blocks
  weren't extracted temporarily before, as required. 
  Now, `read_opus(dsn, data_only = TRUE)` successfully extracts an extra element
  `basic_metadata`, as it does for `data_only = FALSE` (the default). This extra
  information does unlikely to break existing pipeline code that extracts
  spectra with {opusreader2}, because it is a nested list element. This patch
  release also resolves a warning when parsing time information, that was due to
  an extra tab (`"\t"`) that was present in the history text for specific files.
  Thanks @mtalluto for the fix.
  Added extra tests to check for errors and warnings in the example files for
  both `data_only = FALSE` and `data_only = TRUE`).
  Thanks to @dylanbeaudette and @esteveze for reporting the failing extraction of metadata.
  Issue report: [#104](https://github.com/spectral-cockpit/opusreader2/issues/104).
  PR fixed: [#105](https://github.com/spectral-cockpit/opusreader2/pull/105).


# opusreader2 0.6.2.9000 (2023-12-27)

- Select 5 OPUS binary files from different instrument types for tests and 
  vignette ((#103)
- Update first part of vignette for CRAN (#103).


# opusreader2 0.6.2 (2023-12-23)

## Bug fixes

- Hotfix for commit [c8ff2cd](https://github.com/spectral-cockpit/opusreader2/commit/c8ff2cd8e002ed7a992b21053c41877f4a12d533), which accidentally caused a regression, leading to 
  issues [#101](https://github.com/spectral-cockpit/opusreader2/issues/101) and
  [#102](https://github.com/spectral-cockpit/opusreader2/issues/102). 
  It was unnoticed but could have been diagnosed with the {testthat} tests in 
  place. There was also an update of the {tic} template, which did not invoke
  tests yet in the continous integration (CI) run (passed because of unconfigured tests).
  When restricting relevant export, roxygen2 `@export` tags were removed and
  `@internal` added for
  `calc_parameter_chunk_size()`, which made those functions unavailable even
  internally (`"Error in UseMethod("calc_parameter_chunk_size") : no applicable
  method for 'calc_parameter_chunk_size' applied to an object of class "parameter")"`

## Documentation

- `read_opus()`: in return element `ab`, state `Log10` explicitly for calculating
  apparent absorbance ([#94](https://github.com/spectral-cockpit/opusreader2/issues/94); @zecoljls).
- Only export functions relevant to users:
  - core: `read_opus()`, `read_opus_single()`
  - S3 methods for `calc_parameter_chunk_size()`
  - helpers: `opus_file()`


# opusreader2 0.6.1 (2023-11-12)

## OPUS data support

- Support quality test report (#81). This block can be found in 
  `./inst/extdata/new_data/issue81_A1.1.0`. `read_opus()` returns this 
  block as `"quality_test_report"` in the list output.


# opusreader2 0.6.0 (2023-11-12)

- Add first unit tests using the {testhat} framework.
- Allow non-parsable blocks. Add new default so that all blocks that not yet
  mapped are showing up as warnings instead of an error. These blocks will be
  named as `"unknown"` elements in the output of the `read_opus()` list.
  
## OPUS data support

- Internal refactoring (see below) fixes two reading issues:
  - `./inst/extdata/new_data/issue94_RT_01_1_23-02-21_13-23-54.0`: 
    from Bruker 2023 Alpha II mid-IR spectrometer. Due to internal refactoring
    of header parsing (see below) (#94)
  - `./inst/extdata/new_data/issue82_Opus_test`: from Bruker MPA FT-IR 
    spectrometer. Parse block `"b0-c0-t144-a1"`, text type 144 with special
    offset in `parse_chunk.parameter()`. For now classify this block as block
    type `"report_unknown"` (waiting finalize naming until confirmed with
    screenshots from the Bruker OPUS sofware). Also fix `time_saved` by 
    not relying on language settings (#82)
  

## Internal refactoring

- Simplify header parsing in `parse_header()`.
- Work with `raw` vectors instead of `connection` objects to read binary data.
  Parse `raw` vectors directly for functions in `read_bin_types()` and use
  subsetting to slice raw vectors in `base::readBin()` calls instead instead 
  of `seek()`, which was used previously to reposition cursors in raw
  `connection`s.
- `get_meta_timestamp()`: omit language dependent logic using `"time saved"` 
  regular expressions for matching time saved from history block. The first 
  time of sorted `POSIXct` candidates will be returned as time saved.

<!-- NEWS.md is maintained by https://fledge.cynkra.com, contributors should not edit this file -->

# opusreader2 0.5.0.9000 (2023-06-05)

  - implement a `basic_metadata` list element for "opusreader2" class containing key metadata  (#85)


# opusreader2 0.5.0 (2023-06-03)

- Name first level of list (class `"list_opusreader2"`) with base file name of given data source name (DSN) (#83)

- Fix `"list_opusreader2"` indenting when reading files in parallel (#80)

- Add support for progress bars in `read_opus()` (#75)

- Introduce type-stable classes for `read_opus()` and `read_opus_single()` output  (#72):
  - classes "list_opusreader2" and "opusreader2"


# opusreader2 0.4.1 (2023-03-19)

  - patch when `read_opus(..., parallel = TRUE)`: unlist resulting list one level (chunk level); [#80](https://github.com/spectral-cockpit/opusreader2/pull/80).


# opusreader2 0.4.0 (2023-03-14)

  - Feature progress bar for `read_opus()` when reading multiple files in parallel [#75](https://github.com/spectral-cockpit/opusreader2/pull/75).


# opusreader2 0.3.0 (2023-02-16)

  - The exported functions are now (#74):
    - `read_opus()`: Read one or more OPUS files from data source name (`dsn`)
    - `read_opus_single()`: Read a single OPUS file
    - `calc_parameter_chunk_size()`: Calculate the parameter chunk size in bytes


# opusreader2 0.2.0 (2023-02-15)

  - Introduce new S3 classes for the main functions exported (#72):
    - `read_opus()`: S3 class `c("list_opusreader2", "list")`
    - `read_opus_single()`: S3 class `c("opusreader2", "list")`

# opusreader2 0.1.0 (2023-02-08)

## Refactoring

- Internal refactoring (`R/create_dataset.R`). Implement a new key-value mapping
  logic for assigning the integer coded header information. The new order in the
  (composite) key strings follows the sequence of *block*, *channel*, *text* and 
  *additional* type information. The better line-by-line layout of composite 
  keys and mapped information types simplifies the detection of new kind of
  spectral data and parameters that are encoded in header entries (#60).

- Introduce consistent and proactive error reporting when a composite key in 
  are not yet mapped because they are not yet known (`R/create_dataset.R`). 
  This error message includes a recipe how to report new OPUS files with yet 
  unsupported block types (i.e. new instrument features) for {opusreader2}. 
  Together with the composite key generated from the respective the header
  entry, a step-by-step reporting as GitHub issue is proposed. (#60)

# opusreader2 0.0.0.9002 (2022-12-23)

## Documentation

- Update return value of parsed OPUS spectral blocks in `parse_opus()`


# opusreader2 0.0.0.9001 (2022-12-18)

Start versioning with {fledge}.

spectral-cockpit.com proudly introduces {opusreader2} to read binary files 
from FT-IR devices from Bruker Optics GmbH & Co in R. It is a powerhouse that 
fuels speedy extract-transform-load (ETL) data pipelines in spectroscopy
applications. You can continue using state-of-the-art commercial devices
for what they are good at: measurements. Meanwhile, you can rely on open source
technology and trans-disciplinary knowledge to design data processes, and make
best use of the spectroscopic source of information.

{opusreader2} parses and decodes the at first glance puzzling file header
first. The implementation then uses this mapped information as a recipe to read
particular data types from different blocks. Specific byte chunks to be
interpreted are defined by position (offset), read length, bytes per element,
and type (e.g., string, float). With this, all the data can be read and parsed.
We mitigate lock-in at file level. Hence we foster reproducible and trustworthy 
processes in spectral workflows. Nowadays, the new business logic is being more
and more transparent in code, methods used and services offered. Tightly link and
make input data, metadata and outcomes available for economical scaling-up of
diagnostics.

- Extract, transform and load data directly from OPUS binary files

Providing the data and metadata from measurements connects downstream tasks in
order to make IR spectroscopy a ready-made, automatec for diagnostics and monitoring (platform):

- Quality control of measurements; monitoring workflow and metadata
- Continuous spectroscopic diagnostics (data processing, model development,
  inspection, adaption, prediction, and validation). Use MLOps principles.

With our package you can directly read and parse from binary files without
compromising a single bit of precious information saved in these filled 
OPUS binary files.

`read_opus()` is the main function exposed that reads and parses OPUS binary
files from various data sources names (dsn). Currently, we support the 
following `dsn` types:

- *files(s)*: character vector with one path to OPUS file or multiple paths to 
  individual OPUS files
- *folder*: character of length 1 with path to folder with OPUS files to be read
  recursively. Only reads OPUS files with `.<integer>` extension (Usually
  starting from `.0` for unique sample names per measurement.

File names of OPUS files can possibly include plate positions that are postfixed
to the sample names. This is an option in OPUSLab. Kindly note that the 
associated metadata (sample name/ID) and plate position are also stored
internally so that file name changes after measurement could be tracked.

`read_opus` offers four arguments:

- `dsn`: data source name
- `data_only`: switch to extract only spectral data blocks without additional
   information like measurement parameters or environmental conditions.
- `parallel`: not enabled by default. Speed up reads of 1000s of files by 
   chunking list of files across parallel workers. Cross-platform via unified
   {future} framework in R.
- `progress_bar`: optionally show interactive progress bar for single-threaded
  or asynchronous reads.

The interface is minimal and the job of the generic reader function is
well defined by design. This is to make maintenance easy and to avoid breaking
changes in future releases of the package. We importantly avoid feature overload
like this. We plan to release specific helper and wrapper functions that can
come in handy for tailored uses and diagnostic environments. They may also
extract or post-process spectroscopic data and metadata pipelines. Check out
more soon in future releases.
