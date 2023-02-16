#' Parse data, parameters and text from raw vector of OPUS file saved
#' after one spectral measurement of a Bruker FT-IR device.
#'
#' This function is internally used to parse the raw vector of the OPUS file
#' after reading it with `read_opus_raw()`.
#'
#' @param raw a vector containing bytes (class "raw").
#' @param data_only logical (default `FALSE`). Parse and return only spectral
#' data elements from the available blocks. See value returned.
#' @seealso [opusreader2::read_opus_raw()]
#'
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
#' @family core
#' @examples
#' library(opusreader2)
#'
#' dsn <- system.file(
#'   "extdata/test_data/BF_lo_01_soil_cal.1",
#'   package = "opusreader2"
#' )
#'
#' raw <- read_opus_raw(dsn)
#'
#' opus_list <- parse_opus(raw, data_only = FALSE)
#' @keywords internal
parse_opus <- function(raw, data_only) {
  con <- rawConnection(raw)

  raw_size <- length(raw)

  header_data <- parse_header(raw_size, con)

  dataset_list <- lapply(header_data, create_dataset)

  dataset_list <- name_output_list(dataset_list)


  if (data_only) {
    if (any(grepl("^ab$|^refl$", names(dataset_list)))) {
      dataset_list <- extract_data(
        dataset_list,
        c("ab", "refl", "ab_data_param", "refl_data_param")
      )
    } else {
      dataset_list <- extract_data( # nolint
        dataset_list,
        c(
          "ab_no_atm_comp",
          "refl_no_atm_comp",
          "ab_no_atm_comp_data_param",
          "refl_no_atm_comp_data_param"
        )
      )
    }
  } else {
    dataset_list <- lapply(dataset_list, calc_parameter_chunk_size)
  }

  dataset_list <- lapply(dataset_list, function(x) parse_chunk(x, con))

  data_types <- get_data_types(dataset_list) # nolint

  dataset_list <- Reduce(
    function(x, y) prepare_spectra(x, y),
    x = data_types, init = dataset_list
  )

  if (data_only) {
    dataset_list <- dataset_list[lapply(dataset_list, class) == "data"]
  }

  dataset_list <- sort_list_by(dataset_list)

  on.exit(close(con))

  class(dataset_list) <- c("opusreader2", class(dataset_list))

  return(dataset_list)
}
