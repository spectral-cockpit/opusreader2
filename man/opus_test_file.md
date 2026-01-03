

# Get path of a Selected Sample OPUS File Included in the Package

## Description

Utility function that retrieves the location of the sample OPUS binary
file on disk.

## Usage

<pre><code class='language-R'>opus_test_file()
</code></pre>

## Value

a character vector with the path to a selected single sample OPUS file

## Examples

``` r
library("opusreader2")

(fn <- opus_test_file())
```

    [1] "/nix/store/k34a8c73ngaassm1cbiryh5wqdz8p0g5-r-altdoc-0.7.0/library/opusreader2/extdata/test_data/test_spectra.0"
