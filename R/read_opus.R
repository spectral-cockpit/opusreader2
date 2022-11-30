#' Read OPUS binary file of a Bruker spectrometer
#'
#' This function can be used to read and parse OPUS files,
#' to make it usable for other processing steps.
#' @inherit parse_opus return params
#' @param data_only read data and parameters with `FALSE` per default, or only
#' read data
#' @param output_path optional storage path for the parsed output. Default is
#' `NULL`, which only returns the parsed data as an in-memory R object.
#' @param parallel read files in parallel via chunking. Default is `FALSE`.
#' @param progress_bar print a progress bar. Default is `FALSE`.
#' @family core
#' @export
read_opus <- function(dsn,
                      data_only = FALSE,
                      output_path = NULL,
                      parallel = FALSE,
                      progress_bar = FALSE) {


  if (isTRUE(parallel)) {
    class(dsn) <- c(class(dsn), "future")
  }

  if (dir.exists(dns)){
    dsn <- list.files(dns, full.names = T)
  }

  raw_list <- read_opus_raw(dsn)

  dataset_list <- opus_lapply(raw_list, data_only)

  if (length(dataset_list) == 1) {
    dataset_list <- dataset_list[[1]]
  }

  return(dataset_list)
}

read_opus_impl <- function(dsn, data_only, output_path){

  raw <- read_opus_raw(dsn)

  dataset_list <- parse_opus(raw)

  write_opus(dataset_list)

}


opus_lapply <- function(dsn, data_only) UseMethod("opus_lapply")

opus_lapply.future <- function(dsn, data_only) {
  dataset_list <- future.apply::future_lapply(
    dsn,
    function(x) parse_opus(x, data_only)
  )

  return(dataset_list)
}

opus_lapply.default <- function(dsn, data_only) {
  dataset_list <- lapply(
    dsn,
    function(x) parse_opus(x, data_only)
  )

  return(dataset_list)
}
