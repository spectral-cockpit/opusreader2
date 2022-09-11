#' Read OPUS binary file of a Bruker spectrometer
#'
#' This function can be used to read and parse OPUS files,
#' to make it usable for other processing steps.
#' @inherit read_opus_impl return params
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
  if (length(dsn) == 1L) {
    dataset_list <- read_opus_impl(dsn) # nolint
  }
  return(dataset_list)
}