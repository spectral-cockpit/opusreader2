#' parse the header of the opus file
#'
#' @param raw raw vector of the opus binary file
#'
#' @param con connection to the raw vector
#'
#' @export
parse_header <- function(raw, con) {

  # header length in bytes
  header_length <- 504L

  # set first start cursor in bytes;
  # following github.com/qedsoftware/brukeropusreader
  cursor <- 24L
  # number of bytes of block metainfo
  meta_block_size <- 12L

  # file size in bytes
  file_size <- length(raw)

  #result_list <- list()


  raw_header <- raw[1:504]
  con_header <- rawConnection(raw_header)

  unsigned_int_header <- data.frame(int = read_unsigned_int(con_header, 0, 504))
  unsigned_int_header <- transform(unsigned_int_header,plus_1=c(int[-1],504), minus_1=c(0, int[-504]))
  unsigned_int_header$index <- 1:504

  #unsigned_int_header_rev <- rev(unsigned_int_header)

  index_64 <- data.frame(index_64 = which(unsigned_int_header$int == "64"))

  index_64$diff <- c(diff(index_64$index_64), 12)

  real_index <- index_64[index_64$diff > 7,]
  real_index$start <- real_index$index_64 -4

  additional_index <- unsigned_int_header[unsigned_int_header$int == 0 &  unsigned_int_header$plus_1 != 64 & unsigned_int_header$plus_1 > 0 & unsigned_int_header$minus_1 > 0,"index"] -4

  #real_index <- transform(real_index,next_start=c(start[-1],504))

  #real_index$index_64 <- NULL
  #real_index$diff <- NULL

  #real_index_list <- split(real_index, seq(nrow(real_index)))

  all_cursors <- sort(c(real_index$start, additional_index))

  result_list <- lapply(all_cursors, function(x) parse_raw_header(x, con))


  result_list[sapply(result_list, is.null)] <- NULL
  next_offsets <- unlist(lapply(result_list, function(x) x$offset))
  next_offsets <- c(next_offsets[2:length(next_offsets)], file_size)

  result_list <- mapply(function(x, y) c(x, next_offset = list(y)), x=result_list, y=next_offsets,  SIMPLIFY = FALSE)



  # repeat {
  #   if (cursor + meta_block_size >= header_length) {
  #     break
  #   }
  #
  #   block_type   <- read_unsigned_int(con, cursor)
  #   channel_type <- read_unsigned_int(con, cursor + 1L)
  #   text_type    <- read_unsigned_int(con, cursor + 2L)
  #   chunk_size   <- read_signed_int(con, cursor + 4L)
  #   offset       <- read_signed_int(con, cursor + 8L)
  #
  #   if (offset <= 0L) {
  #     break
  #   }
  #
  #   next_offset <- offset + 4L * chunk_size
  #
  #   repeat_list <- list(
  #     block_type = block_type,
  #     channel_type = channel_type,
  #     text_type = text_type,
  #     offset = offset,
  #     next_offset = next_offset,
  #     chunk_size = chunk_size
  #   )
  #
  #   result_list <- c(result_list, list(repeat_list))
  #
  #   if (next_offset >= file_size) {
  #     break
  #   }
  #
  #   cursor <- cursor + 12L
  # }

  # exclude the header chunk, since it is read in this function
  #result_list <- result_list[-1L]

  #close(con)
  return(result_list)
}


parse_raw_header <- function(cursor, con){

  #cursor <- real_index_row$start
  #next_offset <- real_index_row$next_start

  block_type   <- read_unsigned_int(con, cursor)
  channel_type <- read_unsigned_int(con, cursor + 1L)
  text_type    <- read_unsigned_int(con, cursor + 2L)
  chunk_size   <- read_signed_int(con, cursor + 4L)
  offset       <- read_signed_int(con, cursor + 8L)

  if(offset == 0 | text_type == 64){
    out_list <- NULL
  }else{
    out_list <- list(
      block_type = block_type,
      channel_type = channel_type,
      text_type = text_type,
      offset = offset,
      #next_offset = offset + next_offset,
      chunk_size = chunk_size
    )
  }

  return(out_list)
}




# ASCII lookup: take hexadecimal number and output character from extended
# ASCII set
dec_to_ascii <- function(n) {
  rawToChar(as.raw(n))
}
