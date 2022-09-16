#' parse the header of the opus file
#'
#' @param raw_size raw vector of the opus binary file
#'
#' @param con connection to the raw vector
#' @family parsing
#' @export
parse_header <- function(raw_size, con) {

  # header length in bytes
  header_length <- 504L

  # set first start cursor in bytes;
  # following github.com/qedsoftware/brukeropusreader
  cursor <- 24L
  # number of bytes of block metainfo
  meta_block_size <- 12L

  # file size in bytes
  # file_size <- length(raw)

  result_list <- list()

  repeat {
    if (cursor + meta_block_size >= header_length) {
      break
    }

    block_type <- read_unsigned_int(con, cursor)
    channel_type <- read_unsigned_int(con, cursor + 1L)
    text_type <- read_unsigned_int(con, cursor + 2L)
    # we can discuss the name here
    additional_type <- read_unsigned_int(con, cursor + 3L)
    chunk_size <- read_signed_int(con, cursor + 4L)
    offset <- read_signed_int(con, cursor + 8L)

    if (offset <= 0L) {
      break
    }

    next_offset <- offset + 4L * chunk_size

    repeat_list <- list(
      block_type = block_type,
      channel_type = channel_type,
      text_type = text_type,
      additional_type = additional_type,
      offset = offset,
      next_offset = next_offset,
      chunk_size = chunk_size
    )

    result_list <- c(result_list, list(repeat_list))

    if (next_offset >= raw_size) {
      break
    }

    cursor <- cursor + 12L
  }

  # exclude the header chunk, since it is read in this function
  result_list <- result_list[-1L]

  return(result_list)
}



# ASCII lookup: take hexadecimal number and output character from extended
# ASCII set
dec_to_ascii <- function(n) {
  rawToChar(as.raw(n))
}