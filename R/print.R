#' @export
print.list_opusreader2 <- function(x, ...) {
  len <- length(x)
  nm <- if (length(x) != 1) "spectra" else "spectrum"
  cat(paste0("OPUS collection with ", bf(), len, " ", nm, nf(), "\n"))
  utc_times <- unlist(lapply(data, function(x) x$basic_metadata$utc_datetime_posixct))
  utc_range <- as.POSIXct(range(utc_times), origin = "1970-01-01", tz = "UTC")
  cat(paste0(bf(), "Measurement metadata:", nf(), "\n")) 
  cat(paste0("  * date-time range (UTC): ", "[", format(utc_range[1]), " , ", format(utc_range[2]), "]", "\n"))
  invisible(x)
}

bf <- function() "\x1B[1m"

nf <- function() "\x1B[22m"