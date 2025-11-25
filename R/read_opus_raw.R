#' Read the raw vector of an opus data source
#'
#' @inheritParams read_opus_single
#'
#' @return list of raw vectors
#'
#' @keywords internal
read_opus_raw <- function(dsn) {
  if (is.raw(dsn)) {
    return(raw)
  } else {
    dsn <- set_connection_class(dsn)

    raw <- read_raw(dsn)
  }

  return(raw)
}

#' Dispatch method for the open_connection
#'
#' @inheritParams read_opus_single
#' @family connection
#' @keywords internal
read_raw <- function(dsn) UseMethod("read_raw", dsn)

#' method to open the connection for an opus file
#'
#' @inheritParams read_opus_single
#' @keywords internal
read_raw.file <- function(dsn) {
  file_size <- file.size(dsn)

  raw <- readBin(dsn, "raw", n = file_size)

  return(raw)
}

#' define class of dsn
#'
#' @inheritParams read_opus_single
#' @keywords internal
set_connection_class <- function(dsn) {
  if (file.exists(dsn)) {
    class(dsn) <- c(class(dsn), "file")
  }

  return(dsn)
}
