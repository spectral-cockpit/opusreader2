#' read unsigned integer from binary
#'
#' @param raw raw vector
#' @param cursor offset
#' @param n number of elements
read_unsigned_int <- function(raw, cursor, n = 1L) {
  n_int <- n * 1

  # seek_opus(con, cursor)
  out <- readBin(
    raw[cursor:(cursor + n_int)],
    what = "integer",
    n = n,
    size = 1L,
    endian = "little",
    signed = FALSE
  )

  raw <- NULL

  return(out)
}

#' read signed integer from binary
#'
#' @inheritParams read_unsigned_int
read_signed_int <- function(raw, cursor, n = 1L) {
  n_signed_int <- n * 4

  # seek_opus(con, cursor)
  out <- readBin(
    raw[cursor:(cursor + n_signed_int)],
    what = "integer",
    n = n,
    size = 4L,
    endian = "little"
  )

  raw <- NULL

  return(out)
}

#' read character from binary
#' @inheritParams read_unsigned_int
#' @param n_char integer with number of desired characters to read from raw
#' @param encoding encoding to assign character strings that are read. Default
#' is `"latin1"`., which will use Windows Latin 1 (ANSI) encoding. This is
#' how Bruker software OPUS is assumed to commonly store strings.
read_character <- function(raw, cursor, n = 1L, n_char, encoding = "latin1") {
  # seek_opus(con, cursor)


  out <- readBin(
    raw[cursor:(cursor + n_char)],
    what = "character",
    n = n,
    size = 1,
    endian = "little"
  )

  raw <- NULL

  Encoding(out) <- encoding

  return(out)
}

#' read float from binary (single-precision, 32 bits)
#'
#' @inheritParams read_unsigned_int
read_float <- function(raw, cursor, n = 1L) {
  n_float <- n * 4

  # seek_opus(con, cursor)
  out <- readBin(
    raw[cursor:(cursor + n_float)],
    what = "double",
    n = n,
    size = 4L,
    endian = "little"
  )

  raw <- NULL

  return(out)
}

#' read double from binary (double-precision, 64 bits)
#'
#' @inheritParams read_unsigned_int
read_double <- function(raw, cursor, n = 1L) {
  n_double <- n * 8

  # seek_opus(con, cursor)
  out <- readBin(
    raw[cursor:(cursor + n_double)],
    what = "double",
    n = n,
    size = 8L,
    endian = "little"
  )

  raw <- NULL

  return(out)
}
