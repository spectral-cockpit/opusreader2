

# Read OPUS binary files from Bruker spectrometers

## Description

Read and parse OPUS files with spectral data from individual
measurements

## Usage


```r
read_opus(dsn, data_only = FALSE, parallel = FALSE, progress_bar = FALSE)
```


## Arguments

<table role="presentation">
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="dsn">dsn</code>
</td>
<td>
data source name. Can be a path to a specific file or a path to a
directory. The listing of the files in a directory is recursive.
</td>
</tr>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="data_only">data_only</code>
</td>
<td>
read data and parameters with <code>FALSE</code> per default, or only
read data <code>NULL</code>, which only returns the parsed data.
</td>
</tr>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="parallel">parallel</code>
</td>
<td>
read files in parallel via <code>“mirai”</code> (non-blocking parallel
map). Default is <code>FALSE</code>. See section "Details" for more
information.
</td>
</tr>
<tr>
<td style="white-space: nowrap; font-family: monospace; vertical-align: top">
<code id="progress_bar">progress_bar</code>
</td>
<td>
print a progress bar. Default is <code>FALSE</code>.
</td>
</tr>
</table>

## Value

List with OPUS spectra collection of class
<code>list_opusreader2</code>. The individual elements are individual
sample measurement data extracted from the corresponding OPUS binary
files, as parsed from the encoded data blocks.

Each element in <code>list_opusreader2</code> contains metadata and
measurement data equivalent to their names displayed in the Bruker OPUS
viewer software. However, we used snake_case and standardized the naming
for better output handling.

Each parsed block element is a sublist that contains

<strong>1.</strong> the binary read instructions decoded/derived from
the header (<code style="white-space: pre;">$block_type</code>,
<code style="white-space: pre;">$channel_type</code>,
<code style="white-space: pre;">$text_type</code> and
<code style="white-space: pre;">$additional_type</code>,
<code style="white-space: pre;">$offset</code> (bytes),
<code style="white-space: pre;">$next_offset</code> (bytes),
<code style="white-space: pre;">$chunk_size</code> (bytes)).

<strong>2.</strong> if parameter block, nested list of specific
parameters under <code style="white-space: pre;">$parameters</code>,
which has elements named according to capitalized Bruker-internal
"three-letter-string" definitions (e.g., "DPF := Data Point Format").

Possible first-level block names and information provided include:

<ul>
<li>

<strong><code>refl_no_atm_comp_data_param</code></strong> : class
<code>parameter</code> (viewer: "Data Parameters Refl". Parameter list
with metadata for <code>refl</code> data block (<code>refl</code>).

</li>
<li>

<strong><code>refl_no_atm_comp</code></strong>: class <code>data</code>
(spectrum; viewer: "Refl"). Unprocessed (raw; i.e, not atmospherically
compensated) reflectance spectra (<code style="white-space: pre;">:=
sc_sample / sc_ref</code>). Note that this element is the untreated
spectra before an eventual "atmospheric compensation" routine is
applied.

</li>
<li>

<strong><code>refl_data_param</code></strong> : class
<code>parameter</code> (viewer: "Data Parameters Refl"). Parameter list
with metadata for <code>refl</code> data block (metadata of reflectance
spectrum; see <code>refl</code> output). Note that this element only
results if "atmospheric compensation" was activated in the OPUS
measurement settings.

</li>
<li>

<strong><code>refl</code></strong>: class <code>data</code> (spectrum;
viewer: "Refl"). Atmospherically compensated reflectance spectra
(<code style="white-space: pre;">:= sc_sample_corr /
sc_ref_corr</code>). This result spectrum only exists if either
correction of CO2 and/or water vapour bands is set in OPUS setting
(proprietary algorithm; could possibly be reverse engineered). If
<code>refl</code> exists, it has always a corresponding untreated
<code>refl_no_atm_comp</code> spectrum (the latter present in file but
not shown in the OPUS viewer, where only (final) <code>ab</code> is
displayed)

</li>
<li>

<strong><code>quant_report_refl</code></strong>: class
<code>parameter</code> (viewer: "Quant Report Refl"). Quantification
report for tools of multivariate calibration on <code>refl</code> data
(i.e., PLS regression) offered in the QUANT2 OPUS package. Nested list
with Bruker-internal "three-letter-string" definitions. "TIT" is the
title of a nested quantification table, <code>“E\<digit\>\[2\]”</code>
stands probably for entry, <code>“F\<digit\>\[2\]”</code> for field, and
<code>“Z\<digit\>\[2\]”</code> we do not yet know what it maps to. There
seems more information needed, which we can get by expanding the header
parsing algorithm.

</li>
<li>

<strong><code>ab_no_atm_comp_data_param</code></strong> : class
<code>parameter</code> (viewer: "Data Parameters AB"). Parameter list
with metadata for <code>ab</code> data block (spectrum; see
<code>ab</code> output).

</li>
<li>

<strong><code>ab_no_atm_comp</code></strong>: class <code>data</code>
(spectrum; viewer: "Refl"). Unprocessed (raw; i.e, not atmospherically
compensated) reflectance spectra (<code style="white-space: pre;">:=
sc_sample/ sc_ref</code>).

</li>
<li>

<strong><code>ab_data_param</code></strong> : class
<code>parameter</code> (viewer: "Data Parameters Refl"). Parameter list
with metadata for <code>ab</code> data block (spectrum; see
<code>ab</code>). Note that this element only results if "atmospheric
compensation" was activated in the OPUS measurement settings.

</li>
<li>

<strong><code>ab</code></strong>: class <code>data</code> (spectrum;
viewer: "AB"). Atmospherically compensated (apparent) absorbance spectra
(<code style="white-space: pre;">:= log10(1 / (sc_sample_corr /
sc_ref_corr)</code>). Only exists if either correction of CO2 and/or
water vapour bands is set in OPUS setting (proprietary algorithm; could
possibly be reverse engineered). If <code>AB</code> exists, it has
always a corresponding untreated <code>ab_no_atm_comp</code> spectrum
(the latter present in file but not shown in the OPUS viewer, where only
final <code>ab</code> is displayed).

</li>
<li>

<strong><code>quant_report_ab</code></strong>: class
<code>parameter</code> (viewer: "Quant Report AB"). Quantification
report for tools of multivariate calibration on <code>ab</code> data
(i.e., PLS regression) offered in the QUANT2 OPUS package. Nested list
with Bruker-internal "three-letter-string" definitions. "TIT" is the
title of a nested quantification table, <code>“E\<digit\>\[2\]”</code>
stands probably for entry, <code>“F\<digit\>\[2\]”</code> for field, and
<code>“Z\<digit\>\[2\]”</code> we do not yet know what it maps to. There
seems more information needed, which we can get by expanding the header
parsing algorithm.

</li>
<li>

<strong><code>sc_sample_data_param</code></strong>: class
<code>parameter</code> (metadata; viewer: "Data Parameters ScSm").
Describes the <code>sc_sample</code> data block (see
<code>sc_sample</code>).

</li>
<li>

<strong><code>sc_sample</code></strong>: class <code>data</code>
(spectrum). Single channel (sc) spectrum of the sample (y-axis:
intensity).

</li>
<li>

<strong><code>ig_sample_data_param</code></strong>: class
<code>parameter</code> (metadata; viewer: "Data Parameters IgSm").

</li>
<li>

<strong><code>ig_sample</code></strong>: class <code>data</code>
(signal, viewer: "IgSm"). Interferogram of the sample measurement.
Oscillatory signal (x-axis: optical path difference (OPD); y-axis:
amplitude of the signal).

</li>
<li>

<strong><code>sc_ref_data_param</code></strong>: class
<code>parameter</code> (metadata; viewer: "Data Parameters ScRf").
Describes the <code>sc_sample</code> data block (see
<code>sc_ref</code>).

</li>
<li>

<strong><code>sc_ref</code></strong>: class <code>data</code> (spectrum;
viewer: "Data Parameters IgSm"). Single channel (sc) spectrum of the
reference (background material: e.g., gold; y-axis: intensity).

</li>
<li>

<strong><code>ig_ref_data_param</code></strong>: class
<code>parameter</code> (metadata; viewer: "Data Parameters IgRf").

</li>
<li>

<strong><code>ig_ref</code></strong>: class <code>data</code> (spectrum;
viewer: "IgRf"). Interferogram of the reference measurement. (background
material: e.g., gold). Oscillatory signal (x-axis: optical path
difference (OPD); y-axis: amplitude of the signal)

</li>
<li>

<strong><code>optics</code></strong>: class "parameter (metadata;
viewer: "Optic Parameters"). Optic setup and settings such as
"Accessory", "Detector Setting" or "Source Setting".

</li>
<li>

<strong><code>optics_ref</code></strong>: class "parameter (metadata;
viewer: "Optic Parameters Rf"). Optic setup and settings specific to
reference measurement such as "Accessory", "Detector Setting" or "Source
Setting".

</li>
<li>

<strong><code>acquisition_ref</code></strong>: class
<code>parameter</code> (metadata; viewer: "Acquisition parameters Rf".
Settings such as ""Additional Data Treatment", (number) of "Background
Scans" or "Result Spectrum" (e.g. value "Absorbance").

</li>
<li>

<strong><code>fourier_transformation_ref</code></strong>: class
<code>parameter</code> (metadata; viewer: "FT - Parameters Rf"). Fourier
transform parameters of the reference sample like Apodization function
("APF"), end frequency limit ("HFQ"), start frequency limit ("LFQ"),
nonlinearity correction ("NLI"), phase resolution ("PHR"), phase
correction mode ("PHZ"), zero filling factor ("ZFF").

</li>
<li>

<strong><code>fourier_transformation</code></strong>: class
<code>parameter</code> (metadata; viewer: "FT - Parameters"). Fourier
transform parameters of the sample measurement. See
<code>fourier_transformation_ref</code> for possible elements contained.

</li>
<li>

<strong><code>sample</code></strong>: class <code>parameter</code>
(metadata; viewer: "Sample Parameters"). Extra information such as the
"Operator Name", "Experiment", or "Location".

</li>
<li>

<strong><code>acquisition</code></strong>: class <code>parameter</code>
(metadata; viewer. "Acquisition Parameters"). Settings of sample
measurement, such as "Additional Data Treatment", (number) of
"Background Scans" or "Result Spectrum" (e.g. value "Absorbance").

</li>
<li>

<strong><code>instrument_ref</code></strong>: class
<code>parameter</code> (metadata; viewer: "Instrument Parameters Rf").
Detailed instrument properties for the reference measurement, such as
"High Folding Limit", "Number of Sample Scans", or "Actual Signal Gain
2nd Channel".

</li>
<li>

<strong><code>instrument</code></strong>: class <code>parameter</code>
(metadata; viewer: "Instrument Parameters"). Detailed instrument
properties for the sample measurement. See <code>instrument_ref</code>.

</li>
<li>

<strong><code>lab_and_process_param_raw</code></strong>: class
<code>parameter</code> (metadata). Laboratory sample annotations such as
"Product Group", "Product", "Label Product Info 1" (e.g., for
<code>sample_id</code>), "Value Product Info 1" (e.g., the
<code>sample_id</code> value), or the "Measurement Position Microplate"
(e.g., for HTS-XT extension)

</li>
<li>

<strong><code>lab_and_process_param_processed</code></strong>: class
<code>parameter</code> (metadata). Laboratory sample annotations for
measurements done with additional OPUS data processing methods. See
<code>lab_and_process_param_raw</code>

</li>
<li>

<strong><code>info_block</code></strong>: class <code>parameter</code>
(metadata). Infos such as "Operator", measurement "Group", "Sample ID".
These can e.g. be set though the OPUS/LAB sofware interface.

</li>
<li>

<strong><code>history</code></strong>: class <code>parameter</code>
(metadata). Character vector with OPUS command history.

</li>
<li>

<strong><code>unknown</code></strong>: if a block-type can not be
matched, no parsing is done and an empty list entry is returned. This
gives you a hint that there is a block that can not yet be parsed. You
can take further steps by opening an issue.

</li>
</ul>

## Details

<code>read_opus()</code> is the high-level interface to read multiple
OPUS files at once from a data source name (<code>dsn</code>).

It optionally supports parallel reads via the <code>{mirai}</code>
backend. <code>{mirai}</code> provides a highly efficient asynchronous
parallel evaluation framework via the Nanomsg Next Gen (NNG),
high-performance, lightweight messaging library for distributed and
concurrent applications.

When reading in parallel, a progress bar can be enabled.
