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
#' @export
read_opus <- function(dsn,
                      data_only = FALSE,
                      parallel = FALSE,
                      progress_bar = FALSE) {

  if (length(dsn) == 1L && dir.exists(dsn)) {
    dsn <- list.files(
      path = dsn, pattern = "\\.\\d+$", full.names = TRUE, recursive = TRUE
    )
  }


  if (parallel) {
    free_workers <- future::nbrOfFreeWorkers()

    chunked_dsn <- split(dsn, sort(dsn %% free_workers))


    dataset_list <- future.apply::future_lapply(
      chunked_dsn,
      function(x) opus_lapply(x, data_only)
    )

  }else{
    dataset_list <- opus_lapply(dsn, data_only)
  }

  if (length(dataset_list) == 1) {
    dataset_list <- dataset_list[[1]]
  }

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
read_opus_impl <- function(dsn, data_only){

  raw <- read_opus_raw(dsn)

  parsed_data <- parse_opus(raw, data_only)

  return(parsed_data)
}


#' wrapper function to apply the read_opus_impl() functio to a list of
#' data source paths
#'
#' @inheritParams read_opus
#'
#' @export
opus_lapply <- function(dsn, data_only) {
  dataset_list <- lapply(
    dsn,
    function(x) read_opus_impl(x, data_only)
  )

  return(dataset_list)
}
