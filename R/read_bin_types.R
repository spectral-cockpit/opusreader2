#' read unsigned integer from binary
#'
#' @param con connection to raw vector
#' @param cursor offset
#' @param n number of elements
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
read_character <- function(con, cursor, n = 1L, encoding = "latin1") {
  seek_opus(con, cursor)
  out <- readBin(
    con,
    what = "character",
    n = n,
    size = 1,
    endian = "little"
  )
  Encoding(out) <- encoding
  return(out)
}

#' read float from binary (single-precision, 32 bits)
#'
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
