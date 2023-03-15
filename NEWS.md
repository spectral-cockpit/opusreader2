<!-- NEWS.md is maintained by https://fledge.cynkra.com, contributors should not edit this file -->

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
