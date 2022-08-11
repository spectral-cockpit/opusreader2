# reposition cursor for open read connection
seek_opus <- function(con, cursor) {
  seek(con, where = cursor, origin = "start", rw = "read")
}