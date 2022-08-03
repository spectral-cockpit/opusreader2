read_header <- function(raw, nh = 504L) {
  # read raw connection
  con <- rawConnection(raw)

  # set start cursor in bytes
  # cursor <- 32L; in ONO, the start cursor is set to this
  cursor <- 32L

  # file size; n data
  nd <- length(raw)

  offset_list <- list()
  chuck_size_list <- list()
  data_type_list <- list()
  data_text_list <- list()
  channel_type_list <- list()


  while (cursor > 0L) {
    i1 <- cursor
    i2 <- i1 + 4L

    if (i2 <= nh) {

      # position the connection and read from current offset
      seek(con, where = i1, origin = "start", rw = "read")
      # read the offset
      offset <- readBin(con, what = "integer", n = 1L, size = 4L, endian = "little")

      if (offset > 0) {
        offset_list <- c(offset_list, offset)

        # read chunk size (4 bytes)
        seek(con, where = i1 - 4L, origin = "start", rw = "read")
        chunk_size <- readBin(con, what = "integer", n = 1L, size = 4L)
        chuck_size_list <- c(chuck_size_list, chunk_size)

        # read the data type # => does not work yet
        i1 <- cursor - 8L
        i2 <- cursor + 1L
        seek(con, where = i1, origin = "start", rw = "read")
        # read as character
        type <- readBin(
          con,
          what = "integer",
          n = 1L,
          size = 1,
          endian = "little",
          signed = F
        )
        data_type_list <- c(data_type_list, type)

        # read the channel type
        i1 <- cursor - 7L
        i2 <- i1 + 1L
        seek(con, where = i1, origin = "start", rw = "read")
        channel <- readBin(
          con,
          what = "integer",
          n = 1L,
          size = 1,
          endian = "little",
          signed = F
        )
        channel_type_list <- c(channel_type_list, channel)

        # read the text type
        i1 <- cursor - 6L
        i2 <- cursor + 1L
        seek(con, where = i1, origin = "start", rw = "read")
        text <- readBin(
          con,
          what = "integer",
          n = 1L,
          size = 1,
          endian = "little",
          signed = F
        )
        data_text_list <- c(data_text_list, text)

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

  result <- list(offset_list = offset_list,
                 chuck_size_list = chuck_size_list,
                 data_type_list = data_type_list,
                 data_text_list = data_text_list,
                 channel_type_list = channel_type_list)

  return(result)
}




