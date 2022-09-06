#' Read OPUS binary file of a Bruker spectrometer
#'
#' This function can be used to read and parse an OPUS file,
#' to make it usable for other processing steps.
#'
#' @param file character vector with the path to the OPUS file(s)
#' @param progress Logical (defaults to `TRUE` if several files are passed to the `file` parameter, `FALSE` otherwise), whether a progress bar message is printed
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
#' opus_list <- read_opus_file(file)
#'
#' # Reading multiple files at once
#' files <- rep(file, times = 10)
#' pous_list <- read_opus_file(files)
#' @export
#'
read_opus_file <- function(file, progress = !(length(file) == 1), cl = NULL) {

  # Parallel processing requires the `pbapply` package installed
  if ( !is.null(cl) & !requireNamespace("pbapply", quietly = TRUE)) {
    stop("Parallel processing requires the `pbapply` package.", call. = FALSE)
  }

  # Implementation of the multi-file reader used in {opusreader}
  dataset_list <- if (requireNamespace("pbapply", quietly = TRUE) & progress) {
    pbapply::pblapply(
      file,
      function(fn) {

        # Check if file exists
        if (!file.exists(fn)) stop(paste0("File '", fn, "' does not exist"), call. = FALSE)
        # Read raw file
        raw <- readBin(fn, "raw", n = file.size(fn))

        # Parse raw string
        out <- read_opus_raw(raw)

        # Return file content and ad to list
        return(out)
      },
      cl = cl
    )
  } else {
    lapply(
      file,
      function(fn) {

        # Check if file exists
        if (!file.exists(fn)) stop(paste0("File '", fn, "' does not exist"), call. = FALSE)
        # Read raw file
        raw <- readBin(fn, "raw", n = file.size(fn))

        # Parse raw string
        out <- read_opus_raw(raw)

        # Return file content and ad to list
        return(out)
      })
  }


  return(dataset_list)
}
