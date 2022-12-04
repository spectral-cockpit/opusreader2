#' reposition cursor for open read connection
#' @param con connection to raw vector
#' @param cursor cursor position within the connection
seek_opus <- function(con, cursor) {
  seek(con, where = cursor, origin = "start", rw = "read")
}
