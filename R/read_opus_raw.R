#' Read raw string extracted from a OPUS binary file of a Bruker spectrometer
#'
#' This function can be used to read and parse an OPUS raw file,
#' to make it usable for other processing steps.
#'
#' @param raw a raw vector
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
#' @export
#'
read_opus_raw <- function(raw) {

  con <- rawConnection(raw)

  header_data <- parse_header(raw, con)

  dataset_list <- lapply(header_data, create_dataset)

  dataset_list <- lapply(dataset_list, calc_parameter_chunk_size)

  dataset_list <- lapply(dataset_list, function(x) parse_chunk(x, con))

  dataset_list <- name_output_list(dataset_list)

  data_types <- get_data_types(dataset_list)

  dataset_list <- Reduce(
    function(x, y) prepare_spectra(x, y),
    x = data_types, init = dataset_list
  )

  dataset_list <- sort_list_by(dataset_list)

  on.exit(close(con))

  return(dataset_list)
}
