#' read unsigned integer from binary
#'
#' @param con connection to raw vector
#'
#' @param cursor offset
#'
#' @param n number of elements
#'
#' @export
read_unsigned_int <- function(con, cursor, n = 1L) {
  seek_opus(con, cursor)
  out <- readBin(
    con,
    what = "integer",
    n = n,
    size = 1L,
    endian = "little",
    signed = FALSE
  )
  return(out)
}

#' read signed integer from binary
#'
#' @inheritParams read_unsigned_int
#'
#' @export
read_signed_int <- function(con, cursor, n = 1L) {
  seek_opus(con, cursor)
  out <- readBin(
    con,
    what = "integer",
    n = n,
    size = 4L,
    endian = "little"
  )
  return(out)
}

#' read character from binary
#'
#' @inheritParams read_unsigned_int
#'
#' @export
read_character <- function(con, cursor, n = 1L) {
  seek_opus(con, cursor)
  out <- readBin(
    con,
    what = "character",
    n = n,
    size = 1,
    endian = "little"
  )
  return(out)
}

#' read double from binary
#'
#' @inheritParams read_unsigned_int
#'
#' @export
read_double <- function(con, cursor, n = 1L, size) {
  seek_opus(con, cursor)
  out <- readBin(
    con,
    what = "double",
    n = n,
    size = size,
    endian = "little"
  )
  return(out)
}
