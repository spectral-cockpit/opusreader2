#' Read OPUS binary file of a Bruker spectrometer
#'
#' This function can be used to read and parse an OPUS file,
#' to make it usable for other processing steps.
#'
#' @param file character vector with the path to the OPUS file
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
#' @include read_opus_raw.R
#'
#' @examples
#' library(opusreader2)
#'
#' file <- system.file("extdata/test_data/BF_lo_01_soil_cal.1", package = "opusreader2")
#'
#' opus_list <- read_opus_file(file)
#' @export
#'
read_opus_file <- function(file) {

  # Get raw vector
  file_size <- file.size(file)
  raw <- readBin(file, "raw", n = file_size)

  dataset_list<- read_opus_raw(raw)

  return(dataset_list)
}
