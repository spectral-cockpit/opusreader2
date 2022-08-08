read_header <- function(raw) {
  # read raw connection
  con <- rawConnection(raw)

  # header length in bytes
  header_length <- 504L

  # set first start cursor in bytes;
  # following github.com/qedsoftware/brukeropusreader
  cursor <- 24L
  # number of bytes of block metainfo
  meta_block_size <- 12L

  # file size in bytes
  file_size <- length(raw)

  result_list <- list()

  repeat {
    if (cursor + meta_block_size >= header_length) {
      break
    }

    # read the block type
    block_type <- read_block_type(con, cursor)

    # read the channel type
    channel_type <- read_channel_type(con, cursor)

    # read the text type
    text_type <- read_text_type(con, cursor)

    # read chunk size (4 bytes)
    chunk_size <- read_chunk_size(con, cursor)

    # read the offset in bytes
    offset <- read_offset(con, cursor)

    if (offset <= 0L) {
      break
    }


    repeat_list <- list(
      block_type = block_type,
      channel_type = channel_type,
      text_type = text_type,
      offset = offset,
      chunk_size = chunk_size
    )

    result_list <- c(result_list, list(repeat_list))

    next_offset <- offset + 4L * chunk_size

    if (next_offset >= file_size) {
      break
    }

    cursor <- cursor + 12L
  }

  # exclude the header chunk, since it is read in this function
  result_list <- result_list[2:length(result_list)]

  return(result_list)
}

# helpers for reading header parameters and codes ------------------------------

read_block_type <- function(con, cursor) {
  seek(con, where = cursor, origin = "start", rw = "read")
  block_type <- readBin(
    con,
    what = "integer", n = 1L, size = 1L, endian = "little", signed = FALSE
  )
  return(block_type)
}

read_channel_type <- function(con, cursor) {
  seek(con, where = cursor + 1L, origin = "start", rw = "read")
  channel_type <- readBin(
    con,
    what = "integer", n = 1L, size = 1L, endian = "little", signed = FALSE
  )
  return(channel_type)
}

read_text_type <- function(con, cursor) {
  seek(con, where = cursor + 2L, origin = "start", rw = "read")
  channel_type <- readBin(
    con,
    what = "integer", n = 1L, size = 1L, endian = "little", signed = FALSE
  )
  return(channel_type)
}

read_chunk_size <- function(con, cursor) {
  seek(con, where = cursor + 4L, origin = "start", rw = "read")
  chunk_size <- readBin(con,
    what = "integer", n = 1L, size = 4L
  )
  return(chunk_size)
}

read_offset <- function(con, cursor) {
  seek(con, where = cursor + 8L, origin = "start", rw = "read")
  offset <- readBin(con,
    what = "integer", n = 1L, size = 4L, endian = "little"
  )
  return(offset)
}

# ASCII lookup: take hexadecimal number and output character from extended
# ASCII set
dec_to_ascii <- function(n) {
  rawToChar(as.raw(n))
}