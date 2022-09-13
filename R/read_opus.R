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
#' @export
read_opus <- function(dsn,
                      data_only = FALSE,
                      output_path = NULL,
                      parallel = FALSE,
                      progress_bar = FALSE) {
  if (dir.exists(dsn)) {
    dsn <- list.files(dsn, full.names = TRUE)
  }

  if (isTRUE(parallel)) {
    class(dsn) <- c(class(dsn), "future")
  }

  dataset_list <- opus_lapply(dsn, data_only)

  if (length(dataset_list) == 1) {
    dataset_list <- dataset_list[[1]]
  }

  return(dataset_list)
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