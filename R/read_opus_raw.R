#' Read the raw vector of an opus data source
#'
#' @inheritParams read_opus_impl
#'
#' @return list of raw vectors
#'
#' @export
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
#' @inheritParams read_opus_impl
#' @family connection
#' @export
read_raw <- function(dsn) UseMethod("read_raw", dsn)

#' method to open the connection for an opus file
#'
#' @inheritParams read_opus_impl
read_raw.file <- function(dsn) {
  file_size <- file.size(dsn)

  raw <- readBin(dsn, "raw", n = file_size)

  return(raw)
}





#' define class of dsn
#'
#' @inheritParams read_opus_impl
#' @family connection
#' @export
set_connection_class <- function(dsn) {
  if (file.exists(dsn)) {
    class(dsn) <- c(class(dsn), "file")
  }

  return(dsn)
}
