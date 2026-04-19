

# Get File Paths of Sample OPUS Files Included in the Package

## Description

Utility function that retrieves the location of the sample OPUS binary
file on disk.

## Usage


```r
opus_test_dsn()
```


## Value

a character vector with the paths OPUS files included in the package

## Examples

``` r
library("opusreader2")

(dsn <- opus_test_dsn())
```

    [1] "/nix/store/738by2967nd1in6cac2j5lmdzivb63bv-r-altdoc-0.7.0/library/opusreader2/extdata/test_data"
