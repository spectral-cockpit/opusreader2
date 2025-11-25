#' Get path of a Selected Sample OPUS File Included in the Package
#'
#' Utility function that retrieves the location of the sample OPUS
#' binary file on disk.
#' @return a character vector with the path to a selected single sample OPUS
#' file
#' @export
#' @examples
#' (fn <- opus_test_file())
opus_test_file <- function() {
  system.file("extdata", "test_data", "test_spectra.0", package = "opusreader2")
}


#' Get File Paths of Sample OPUS Files Included in the Package
#'
#' Utility function that retrieves the location of the sample OPUS
#' binary file on disk.
#' @return a character vector with the paths OPUS files included in the package
#' @export
#' @examples
#' (dsn <- opus_test_dsn)
opus_test_dsn <- function() {
  system.file("extdata", "test_data", package = "opusreader2")
}
