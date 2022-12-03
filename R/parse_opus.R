#' Parse data and parameters of OPUS binary file of a Bruker spectrometer
#'
#' This function can be used to read and parse OPUS files,
#' to make it usable for other processing steps.
#'
#' @param raw data source name; can be a file path to an OPUS file or directly a
#'  raw vector
#'
#' @param data_only TRUE or FALSE if only the ab or refl data should be returned
#'
#' @return list containing the different data chunks of an OPUS file, possibly:
#' * `refl_data_param`:
#' * `refl`:
#' * `quant_report_refl`:
#' * `sc_sample_data_param`:
#' * `sc_sample`:
#' * `sc_ref_data_param`:
#' * `sc_ref`:
#' * `optics`:
#' * `optics_ref`:
#' * `acquisition_ref`:
#' * `fourier_transformation_ref`:
#' * `fourier_transformation`:
#' * `sample`:
#' * `acquisition`:
#' * `instrument_ref`:
#' * `instrument`:
#' * `lab_and_process_param_1`:
#' * `lab_and_process_param_2`:
#' * `info_block`:
#' * `history`:
#'
#' @family core
#' @examples
#' library(opusreader2)
#'
#' dsn <- system.file("extdata/test_data/BF_lo_01_soil_cal.1", package = "opusreader2")
#'
#' raw <- read_opus_raw(dsn)
#'
#' opus_list <- parse_opus(raw, data_only = FALSE)
#' @export
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
      dataset_list <- extract_data(
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

  data_types <- get_data_types(dataset_list)

  dataset_list <- Reduce(
    function(x, y) prepare_spectra(x, y),
    x = data_types, init = dataset_list
  )

  if (data_only) {
    dataset_list <- dataset_list[lapply(dataset_list, class) == "data"]
  }

  dataset_list <- sort_list_by(dataset_list)

  on.exit(close(con))

  return(dataset_list)
}



