

# Read a single OPUS file

## Description

Read a single OPUS file

## Usage


```r
read_opus_single(dsn, data_only = FALSE)
```


## Arguments

<table role="presentation">
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="dsn">dsn</code>
</td>
<td>
source path of an opus file
</td>
</tr>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="data_only">data_only</code>
</td>
<td>
read data and parameters with <code>FALSE</code> per default, or only
read data
</td>
</tr>
</table>

## Value

list with parsed OPUS measurement and data blocks of the spectrum
measurement contained in the OPUS file. See <code>read_opus()</code> for
details on the list elements returned (first-level block names and
information provided).
