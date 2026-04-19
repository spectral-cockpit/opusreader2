

# Get path of a Selected Sample OPUS File Included in the Package

## Description

Utility function that retrieves the location of the sample OPUS binary
file on disk.

## Usage


```r
opus_test_file()
```


## Value

a character vector with the path to a selected single sample OPUS file

## Examples

``` r
library("opusreader2")

(fn <- opus_test_file())
```

    [1] "/nix/store/738by2967nd1in6cac2j5lmdzivb63bv-r-altdoc-0.7.0/library/opusreader2/extdata/test_data/test_spectra.0"
