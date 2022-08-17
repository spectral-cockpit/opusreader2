#' @name opus_file
#' @title Get location of a sample OPUS file
#' @description Utility function that retrieves the location of the sample OPUS
#' binary file on disk.
#' @return a character vector storing the location of the sample OPUS file
#' @export
#' @examples
#' fn <- opus_file()
#' fn
opus_file <- function() {
  system.file("extdata/test_data", "test_spectra.0", package = "opusreader2")
}