#' Plot spectra read from OPUS files
#'
#' @param data list of class "opusreader2" (single OPUS file) or both
#' "opusreader2" and "list_opusreader2", containing spectral data parsed from
#' Bruker OPUS binary files.
#' @param data_type character vector of length one with desired spectral data
#' type to plot.
#' #' @family core
#' @return a base R plot with spectra
#'
#' @export
plot <- function(data, data_type) {
  UseMethod("plot")
}


plot.opusreader2 <- function(data, data_type) {
  validate_plot(data, data_type)

  base::plot(
    x = x,
    y = y,
    type = "l",
    lwd = 1.5,
    xlab = xlab,
    ylab = ylab
  )
}

validate_plot <- function(data, data_type) {
  stopifnot(
    inherits(data, "opusreader2")
  )
}
