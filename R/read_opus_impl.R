#' Read OPUS binary file of a Bruker spectrometer
#'
#' This function can be used to read and parse OPUS files,
#' to make it usable for other processing steps.
#'
#' @param dsn data source name; can be a file path to an OPUS file or directly a
#'  raw vector
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
#' @examples
#' library(opusreader2)
#'
#' dsn <- system.file("extdata/test_data/BF_lo_01_soil_cal.1", package = "opusreader2")
#'
#' opus_list <- read_opus_impl(dsn)
#' @export
read_opus_impl <- function(dsn) {
  if (missing(dsn)) {
    stop("dsn should specify a data source or filename")
  }

  dsn <- set_connection_class(dsn)

  con <- open_connection(dsn)

  raw_size <- get_raw_size(dsn)

  header_data <- parse_header(raw_size, con)

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

#' define class of dsn
#'
#' @inheritParams read_opus
#'
#' @export
set_connection_class <- function(dsn) {
  if (is.raw(dsn)) {
    class(dsn) <- c(class(dsn), "raw")
  } else if (file.exists(dsn)) {
    class(dsn) <- c(class(dsn), "file")
  }

  return(dsn)
}

#' Dispatch method for get_raw_size
#'
#' @inheritParams read_opus
#'
#' @export
get_raw_size <- function(dsn) UseMethod("get_raw_size", dsn)

#' method to get the raw size of a file
#'
#' @inheritParams read_opus
get_raw_size.file <- function(dsn) {
  size <- file.size(dsn)
  return(size)
}

#' method to get the raw size of a raw vector
#'
#' @inheritParams read_opus
#'
#' @export
get_raw_size.raw <- function(dsn) {
  size <- length(dsn)
  return(size)
}

#' Dispatch method for the open_connection
#'
#' @inheritParams read_opus
#'
#' @export
open_connection <- function(dsn) UseMethod("open_connection", dsn)

#' method to open the connection for an opus file
#'
#' @inheritParams read_opus
open_connection.file <- function(dsn) {
  file_size <- get_raw_size(dsn)

  raw <- readBin(dsn, "raw", n = file_size)

  con <- open_connection.raw(raw)

  return(con)
}

#' method to open the connection directly to a raw vector
#'
#' @inheritParams read_opus
#'
#' @export
open_connection.raw <- function(dsn) {
  con <- rawConnection(dsn)
}