#' read unsigned integer from binary
#'
#' @param con connection to raw vector
#' @param cursor offset
#' @param n number of elements
#' @family read_bytes
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
#' @family read_bytes
#' @inheritParams read_unsigned_int
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
#' @family read_bytes
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

#' read float from binary (single-precision, 32 bits)
#'
#' @family read_bytes
#' @inheritParams read_unsigned_int
read_float <- function(con, cursor, n = 1L) {
  seek_opus(con, cursor)
  out <- readBin(
    con,
    what = "double",
    n = n,
    size = 4L,
    endian = "little"
  )
}

#' read double from binary (double-precision, 64 bits)
#'
#' @family read_bytes
#' @inheritParams read_unsigned_int
read_double <- function(con, cursor, n = 1L) {
  seek_opus(con, cursor)
  out <- readBin(
    con,
    what = "double",
    n = n,
    size = 8L,
    endian = "little"
  )
  return(out)
}