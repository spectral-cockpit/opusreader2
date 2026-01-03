

# Get File Paths of Sample OPUS Files Included in the Package

## Description

Utility function that retrieves the location of the sample OPUS binary
file on disk.

## Usage

<pre><code class='language-R'>opus_test_dsn()
</code></pre>

## Value

a character vector with the paths OPUS files included in the package

## Examples

``` r
library("opusreader2")

(dsn <- opus_test_dsn)
```

    function () 
    {
        system.file("extdata", "test_data", package = "opusreader2")
    }
    <bytecode: 0x5633b04a28a8>
    <environment: namespace:opusreader2>
