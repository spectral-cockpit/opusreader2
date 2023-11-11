#' parse the header of the opus file
#'
#' @param raw_size raw vector of the opus binary file
#'
#' @param con connection to the raw vector
#' @family parsing
#' @keywords internal
parse_header <- function(raw) {
  # header length in bytes
  header_length <- 504L

  # set first start cursor in bytes;
  # following github.com/qedsoftware/brukeropusreader
  start_cursor <- 25L

  all_cursors <- seq(start_cursor,header_length, 12L)

  out <- lapply(all_cursors, function(x) test_header_parse(raw, x))

  out[sapply(out, is.null)] <- NULL

  out <- out[-1]

  return(out)
}



# ASCII lookup: take hexadecimal number and output character from extended
# ASCII set
dec_to_ascii <- function(n) {
  rawToChar(as.raw(n))
}



test_header_parse <- function(raw, cursor){

  offset <- read_signed_int(raw, cursor + 8L)

  if (offset <= 0L) {
    return(NULL)
  }
  chunk_size <- read_signed_int(raw, cursor + 4L)
  next_offset <- offset + 4L * chunk_size

  # if(next_offset > length(raw)){
  #   browser()
  #   chunk_size <- length(raw) - offset
  # }


  repeat_list <- list(
    block_type = read_unsigned_int(raw, cursor),
    channel_type = read_unsigned_int(raw, cursor + 1L),
    text_type = read_unsigned_int(raw, cursor + 2L),
    additional_type = read_unsigned_int(raw, cursor + 3L),
    offset = offset,
    next_offset = next_offset,
    chunk_size = chunk_size
  )

  return(repeat_list)
}


