read_header <- function(raw, nh = 504L) {
  # read raw connection
  con <- rawConnection(raw)

  # set start cursor in bytes
  # cursor <- 32L; in ONO, the start cursor is set to this
  cursor <- 44L

  # file size; n data
  nd <- length(raw)

  while (cursor > 0L) {
    i1 <- cursor
    i2 <- i1 + 4L

    if (i2 <= nh) {

      # position the connection and read from current offset
      seek(con, where = i1, origin = "start", rw = "read")
      # read the offset
      offset <- readBin(con, what = "integer", n = 1L, size = 4L)

      if (offset > 0) {

        # read chunk size (4 bytes)
        seek(con, where = i1 - 4L, origin = "start", rw = "read")
        chunk_size <- readBin(con, what = "integer", n = 1L, size = 4L)

        # read the data type # => does not work yet
        i1 <- cursor - 8L
        i2 <- i1 + 1L
        seek(con, where = i1, origin = "start", rw = "read")
        # read as character
        type <- readBin(
          con,
          what = "character",
          n = 1L,
          size = 1L,
          endian = "little"
        )

        # read the channel type
        i1 <- cursor - 7L
        i2 <- i1 + 1L
        seek(con, where = i1, origin = "start", rw = "read")
        channel <- readBin(
          con,
          what = "character",
          n = 1L,
          size = 1L,
          endian = "little"
        )

        # read the text type
        i1 <- cursor - 6L
        i2 <- cursor + 1L
        seek(con, where = i1, origin = "start", rw = "read")
        text <- readBin(
          con,
          what = "character",
          n = 1L,
          size = 1L,
          endian = "little"
        )

        next_offset <- offset + 4 * chunk_size

        if (next_offset >= nd) {
          cursor <- -1L
        } else {
          cursor <- cursor + 12L
        }
      } else {
        cursor <- -1L
      }
    } else {
      cursor <- -1L
    }
  }
}