# Reading OPUS binary files from Bruker® spectrometers in R
Philipp Baumann and Thomas Knecht
2026-03-01

# Motivation

Spectrometers from [Bruker® Optics GmbH &
Co.](https://www.bruker.com/en.html) save spectra in a special binary
file format called OPUS. The OPUS suite and file specification are
proprietary, therefore we have reverse-engineered our reader. With
{opusreader2}, you can extract your spectroscopic data from binary files
for most Fourier-Transform Infrared (FT-IR) spectrometers from Bruker®
Optics GmbH directly in R.

Each OPUS file is linked to one aggregated sample measurement, which is
usually obtained using the OPUS spectroscopy software. These files have
numbers as file extensions, and the numbers typically increase
sequentially for each sample name, based on the settings chosen in the
OPUS software.

# OPUS data extraction

Each OPUS file is processed by first extracting metadata information
from a dedicated part of the file header. As the picture below shows,
the content of the files changes based on the instrument type, the data
(spectrum) blocks that the user chooses to save, and the specific
measurement settings.

<figure id="fig:opus_settings">
<img src="../images/opus-measurement-settings.png"
alt="OPUS measurement settings for Bruker INVENIO® Fourier-transform (FT) mid-infrared spectrometer" />
<figcaption aria-hidden="true">OPUS measurement settings for Bruker
INVENIO® Fourier-transform (FT) mid-infrared spectrometer</figcaption>
</figure>

In addition to result spectra, the binary files include:

- a comprehensive set of measurement parameters (configurations,
  conditions)
- single-channel data from background measurements performed before the
  sample
- other types of intermediate spectra

Currently, we support the *“data blocks to be saved”* for
Fourier-transform infrared spectrometers.

## Reading and parsing OPUS files in R

The main function, `read_opus()`, reads one or more OPUS files and
returns a nested list of class `list_opusreader2`. Each list contains
both the spectral data and metadata for each file.

Let’s see how this works using an example file from a Bruker ALPHA®
spectrometer. This instrument measures mid-infrared spectra, here using
a diffuse-reflectance accessory. The soil sample measurement shown is
included with the package and is also part of the data set in [Baumann
et al. (2020)](https://soil.copernicus.org/articles/7/717/2021/).

<figure>
<img src="../images/OPUS_block1.png"
alt="Data parameters for absorbance (AB) spectrum" />
<figcaption aria-hidden="true">Data parameters for absorbance (AB)
spectrum</figcaption>
</figure>

We can extract all these blocks from the example OPUS file. In fact, we
can access even more blocks than are displayed in the official OPUS
software.

``` r
library("opusreader2")
file_1 <- opus_test_file()
spectrum_1 <- read_opus(dsn = file_1)
```

The `dsn` argument is the data source name. It can be a character vector
of folder paths (to read files recursively) or specific OPUS file paths.

**`read_opus()`** returns a nested list of class `"list_opusreader2"`.

``` r
print(spectrum_1)
#> ╔==============================================================================╗ 
#>                      OPUS collection with [1m1 spectrum[22m                      
#> ╚==============================================================================╝ 
#> [1mMeasurement metadata:[22m
#> * date-time range (UTC): [2020-05-10 21:10:26 , 2020-05-10 21:10:26]
#> [1m 
#> * data blocks (#spectra) ------------------------------------------------------- 
#> [22m   refl_no_atm_comp (1);   sc_ref (1);   sc_sample (1);
#> [1m 
#> * parameter blocks (#spectra) -------------------------------------------------- 
#> [22m   acquisition (1);   acquisition_ref (1);   fourier_transformation (1); 
#>   fourier_transformation_ref (1);   info_block (1);   instrument (1); 
#>   instrument_ref (1);   lab_and_process_param_processed (1); 
#>   lab_and_process_param_raw (1);   optics (1);   optics_ref (1); 
#>   quant_report_refl (1);   refl_no_atm_comp_data_param (1);   sample (1); 
#>   sc_ref_data_param (1);   sc_sample_data_param (1);
class(spectrum_1)
#> [1] "list_opusreader2" "list"
names(spectrum_1)
#> [1] "test_spectra.0"
```

At the top level, the list structure matches how data is organized in
the Bruker OPUS viewer.

``` r
meas_1 <- spectrum_1[["BF_lo_01_soil_cal.1"]]
names(meas_1)
#> NULL
```

To understand block names and their contents, see the help page
`?read_opus`. Block names use `camel_case` at the second level of the
`"opusreader2_list"` output, making them easy to access
programmatically.

Printing the entire `"opusreader2_list"` can flood the console. For
easier exploration, use RStudio’s *list preview* with `View(spectrum_1)`
or examine specific elements with `names()` and `str()`.

Some list elements may not be visible in the Bruker® viewer pane, but we
compile them because they are either useful or actually part of the
files:

1.  `basic_metadata`: Minimal metadata to identify measurements,
    including file name, sample name, and timestamps. Useful for
    organizing spectral libraries and prediction workflows.
2.  `ab_no_atm_comp_data_param`: Parameters for the absorbance (AB)
    block before atmospheric compensation.
3.  `ab_no_atm_comp`: Absorbance data before atmospheric compensation.

``` r
str(meas_1$basic_metadata)
#>  NULL
```

All types of data and parameters within OPUS files are encoded with
three capital letters each.

For example, to check the frequency of the first point (FXV), use:

``` r
meas_1$ab_data_param$parameters$FXV$parameter_value
#> NULL
```

Besides the data or parameter values, the output of each parsed OPUS
block contains the block type, channel type, text type, additional type,
the offset in bytes, next offset in bytes, and the chunk size in bytes
for particular data blocks. This is decoded from the file header and
allows for traceability in the parsing process.

``` r
class(meas_1$ab_data_param)
#> [1] "NULL"
str(meas_1$ab_data_param)
#>  NULL
```

``` r
str(meas_1$instrument)
#>  NULL
```

This example spectrum was measured with atmospheric compensation
(removing masking information from carbon dioxide and water vapor
bands), as set in the OPUS software. OPUS files track all processing
steps and macros, so you can access both raw and processed data. This
enables thorough quality control before modeling or making predictions
on new samples.

## Reading OPUS files recursively from a folder

You can also provide a folder as the data source name (`dsn`). This
makes it easy to read all OPUS files found within a folder and its
subfolders. Here, we demonstrate this using the test files that come
with the {opusreader2} package, which are also used for unit testing.

``` r
test_dsn <- system.file("extdata", "test_data", package = "opusreader2")
data_test <- read_opus(dsn = test_dsn)
names(data_test)
#> [1] "617262_1TP_C-1_A5.0" "629266_1TP_A-1_C1.0" "BF_lo_01_soil_cal.1"
#> [4] "MMP_2107_Test1.001"  "test_spectra.0"
```

To get the instrument name from each test file, you can use:

``` r
get_instrument_name <- function(data) {
  return(data$instrument$parameters$INS$parameter_value)
}

lapply(data_test, get_instrument_name)
#> $`617262_1TP_C-1_A5.0`
#> [1] "INVENIO-R"
#> 
#> $`629266_1TP_A-1_C1.0`
#> [1] "VERTEX 70"
#> 
#> $BF_lo_01_soil_cal.1
#> [1] "Alpha"
#> 
#> $MMP_2107_Test1.001
#> [1] "Tango"
#> 
#> $test_spectra.0
#> [1] "TENSOR II"
```

## Reading OPUS files in parallel

We implemented a parallel interface in `read_opus()` to efficiently read
large collections of spectra from multiple OPUS files. The default and
recommended backend, [mirai](https://mirai.r-lib.org/), orchestrates
reading files concurrently using asynchronous parallel mapping over
individual OPUS files. The main advantage is faster reads, better and
also fault-tolerant error handling (i.e. custom) actions when a file
cannot be read.

Behind the scene, mirai uses
[nanonext](https://github.com/r-lib/nanonext/) and
[NNG](https://nng.nanomsg.org/) (Nanomsg Next Gen) messaging, which
allows high throughput and low latency between individual R processes.

All you have to do is launching daemons.

``` r
if (!require("mirai")) {
  library("mirai")
  daemons(n = 2L, dispatcher = TRUE)

  (data <- read_opus(dsn = files_1000, parallel = TRUE))
}
```

The task of reading files can be done locally or through distributed
systems over a network. For further details, check out the mirai, and
its vignettes.
