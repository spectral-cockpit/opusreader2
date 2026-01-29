

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

    [1] "/nix/store/k34a8c73ngaassm1cbiryh5wqdz8p0g5-r-altdoc-0.7.0/library/opusreader2/extdata/test_data"
