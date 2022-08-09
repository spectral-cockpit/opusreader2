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


read_double <- function(con, cursor, n = 1L) {
  seek_opus(con, cursor)
  out <- readBin(
    con,
    what = "double",
    n = n,
    size = 4L,
    endian = "little"
  )
  return(out)
}
