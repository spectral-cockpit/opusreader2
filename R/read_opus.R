#' Read OPUS binary file of a Bruker spectrometer
#'
#' This function can be used to read and parse OPUS files,
#' to make it usable for other processing steps.
#' @param dsn data source name. Can be a path to a specific file or a path to a
#' directory. The listing of the files in a directory is recursive.
#' @param data_only read data and parameters with `FALSE` per default, or only
#' read data
#' `NULL`, which only returns the parsed data as an in-memory R object.
#' @param parallel read files in parallel via chunking. Default is `FALSE`.
#' @param progress_bar print a progress bar. Default is `FALSE`.
#' @family core
#' @return Nested list (S3 object) containing the parsed contents of the binary
#' encoded blocks of an OPUS file. The first level names of the list correspond
#' to the display names as shown in the Bruker OPUS viewer software. However, in
#' snake_case and more standardized naming to allow for better output handling.
#' Each parsed block element is a sublist containing **a)** the binary read
#' instructions decoded/derived from the header (`$block_type`, `$channel_type`,
#' `$text_type` and `$additional_type`, `$offset` (bytes), `$next_offset`
#' (bytes), `$chunk_size` (bytes)); **b)** if parameter block, nested list of
#'  specific parameters under `$parameters`, which has elements named according
#'  to capitalized Bruker-internal "three-letter-string" definitions (e.g.,
#'  "DPF := Data Point Format"). Possible first-level block names and
#'  information provided include:
#' * **`refl_no_atm_comp_data_param`** : class "parameter"
#'    (viewer: "Data Parameters Refl". Parameter list with metadata for `refl`
#'    data block (`refl`).
#' * **`refl_no_atm_comp`**: class "data" (spectrum; viewer: "Refl").
#'   Unprocessed (raw; i.e, not atmospherically compensated) reflectance spectra
#'   (`:= sc_sample / sc_ref`). Note that this element is the
#'  untreated spectra before an eventual "atmospheric compensation"
#'  routine is applied.
#' * **`refl_data_param`** : class "parameter" (viewer: "Data Parameters Refl").
#'    Parameter list with metadata for `refl` data block (metadata of
#'    reflectance spectrum; see `refl` output).
#'    Note that this element only results if "atmospheric compensation" was
#'    activated in the OPUS measurement settings.
#' * **`refl`**: class "data" (spectrum; viewer: "Refl"). Atmospherically
#'   compensated reflectance spectra (`:= sc_sample_corr / sc_ref_corr`). This
#'   result spectrum only exists if either correction of CO2 and/or water vapour
#'   bands is set in OPUS setting (proprietary algorithm; could possibly be
#'   reverse engineered). If `refl` exists, it has always a corresponding
#'   untreated `refl_no_atm_comp` spectrum  (the latter present in file but not
#'   shown in the OPUS viewer, where only (final) `ab` is displayed)
#' * **`quant_report_refl`**: class "parameter" (viewer: "Quant Report Refl").
#'   Quantification report for tools of multivariate calibration on `refl` data
#'   (i.e., PLS regression) offered in the QUANT2 OPUS package. Nested list with
#'   Bruker-internal "three-letter-string" definitions. "TIT" is the title of
#'   a nested quantification table, `"E<digit>[2]"` stands probably for entry,
#'   `"F<digit>[2]"` for field, and `"Z<digit>[2]"` we do not yet know what it
#'   maps to. There seems more information needed, which we can get by expanding
#'   the header parsing algorithm.
#' * **`ab_no_atm_comp_data_param`** : class "parameter"
#'    (viewer: "Data Parameters AB"). Parameter list with metadata for `ab`
#'    data block (spectrum; see `ab` output).
#' * **`ab_no_atm_comp`**: class "data" (spectrum; viewer: "Refl").
#'   Unprocessed (raw; i.e, not atmospherically compensated) reflectance spectra
#'   (`:= sc_sample/ sc_ref`).
#' * **`ab_data_param`** : class "parameter" (viewer: "Data Parameters Refl").
#'    Parameter list with metadata for `ab` data block (spectrum; see `ab`).
#'    Note that this element only results if "atmospheric compensation" was
#'    activated in the OPUS measurement settings.
#' * **`ab`**: class "data" (spectrum; viewer: "AB"). Atmospherically
#'   compensated (apparent) absorbance spectra
#'   (`:= log(1 / (sc_sample_corr / sc_ref_corr)`). Only
#'   exists if either correction of CO2 and/or water vapour bands is set in OPUS
#'   setting (proprietary algorithm; could possibly be reverse engineered).
#'   If `AB` exists, it has always a corresponding untreated
#'   `ab_no_atm_comp` spectrum (the latter present in file but not shown in
#'   the OPUS viewer, where only final `ab` is displayed).
#' * **`quant_report_ab`**: class "parameter" (viewer: "Quant Report AB").
#'   Quantification report for tools of multivariate calibration on `ab` data
#'   (i.e., PLS regression) offered in the QUANT2 OPUS package. Nested list with
#'   Bruker-internal "three-letter-string" definitions. "TIT" is the title of
#'   a nested quantification table, `"E<digit>[2]"` stands probably for entry,
#'   `"F<digit>[2]"` for field, and `"Z<digit>[2]"` we do not yet know what it
#'   maps to. There seems more information needed, which we can get by expanding
#'   the header parsing algorithm.
#' * **`sc_sample_data_param`**: class "parameter" (metadata; viewer:
#'   "Data Parameters ScSm").
#'   Describes the `sc_sample` data block (see `sc_sample`).
#' * **`sc_sample`**: class "data" (spectrum). Single channel (sc) spectrum of
#'  the sample (y-axis: intensity).
#' * **`ig_sample_data_param`**: class "parameter" (metadata; viewer:
#'   "Data Parameters IgSm").
#' * **`ig_sample`**: class "data" (signal, viewer: "IgSm").
#'   Interferogram of the sample measurement. Oscillatory signal
#'   (x-axis: optical path difference (OPD); y-axis: amplitude of the signal).
#' * **`sc_ref_data_param`**: class "parameter" (metadata; viewer:
#'   "Data Parameters ScRf").
#'   Describes the `sc_sample` data block (see `sc_ref`).
#' * **`sc_ref`**: class "data" (spectrum; viewer: "Data Parameters IgSm").
#'   Single channel (sc) spectrum of the reference (background material: e.g.,
#'   gold; y-axis: intensity).
#' * **`ig_ref_data_param`**: class "parameter" (metadata; viewer:
#'   "Data Parameters IgRf").
#' * **`ig_ref`**: class "data" (spectrum; viewer: "IgRf").
#'   Interferogram of the reference measurement. (background material: e.g.,
#'   gold). Oscillatory signal (x-axis: optical path difference (OPD);
#'   y-axis: amplitude of the signal)
#' * **`optics`**: class "parameter (metadata; viewer: "Optic Parameters").
#'   Optic setup and settings such as "Accessory", "Detector Setting" or
#'   "Source Setting".
#' * **`optics_ref`**: class "parameter (metadata; viewer: "Optic Parameters
#'   Rf"). Optic setup and settings specific to reference measurement such as
#'  "Accessory", "Detector Setting" or "Source Setting".
#' * **`acquisition_ref`**: class "parameter" (metadata; viewer: "Acquisition
#'   parameters Rf". Settings such as ""Additional Data Treatment", (number) of
#'   "Background Scans" or "Result Spectrum" (e.g. value "Absorbance").
#' * **`fourier_transformation_ref`**:
#' * **`fourier_transformation`**: class "parameter"
#' * **`sample`**:
#' * **`acquisition`**:
#' * **`instrument_ref`**:
#' * **`instrument`**:
#' * **`lab_and_process_param_1`**:
#' * **`lab_and_process_param_2`**:
#' * **`info_block`**:
#' * **`history`**:
#'
#' @export
read_opus <- function(dsn,
                      data_only = FALSE,
                      parallel = FALSE,
                      progress_bar = FALSE) {
  check_logical(data_only)
  check_logical(parallel)
  check_logical(progress_bar)

  if (length(dsn) == 1L && dir.exists(dsn)) {
    dsn <- list.files(
      path = dsn, pattern = "\\.\\d+$", full.names = TRUE, recursive = TRUE
    )
  }

  if (!isTRUE(parallel)) {
    dataset_list <- opus_lapply(dsn, data_only)
  } else {
    check_future()

    free_workers <- future::nbrOfFreeWorkers()

    chunked_dsn <- split(dsn, seq_along(dsn) %% free_workers)

    dataset_list <- future.apply::future_lapply(
      chunked_dsn,
      function(x) opus_lapply(x, data_only)
    )
  }

  class(dataset_list) <- c("list_opusreader2", class(dataset_list))

  return(dataset_list)
}


#' Read a single opus file
#'
#' @param dsn source path of an opus file
#'
#' @param data_only read data and parameters with `FALSE` per default, or only
#' read data
#'
#' @export
read_opus_single <- function(dsn, data_only = FALSE) {
  raw <- read_opus_raw(dsn)

  parsed_data <- parse_opus(raw, data_only)

  return(parsed_data)
}


#' wrapper function to apply the read_opus_single() function to a list of
#' data source paths
#'
#' @inheritParams read_opus
#'
#' @keywords internal
opus_lapply <- function(dsn, data_only) {
  dataset_list <- lapply(
    dsn,
    function(x) read_opus_single(x, data_only)
  )

  return(dataset_list)
}
