#' read chunk method
#' @export
parse_chunk <- function(ds, con) UseMethod("read_chunk")

#' read chunk method for text
#' @export
parse_chunk.text <- function(ds, con){


  # ds$value <- value
  # return(ds)
}

#' read chunk method for parameter
#' @export
parse_chunk.parameter <- function(ds, con){

  cursor <- ds$offset
  chunk_size <- ds$chunk_size

  parameter_types <- c('int', 'float', 'str', 'str', 'str')

  repeat {

    parameter_name <- read_character(con, cursor, n = 3L)

    if(parameter_name == "END"){
      break
    }

    type_index <- read_unsigned_int(con, cursor + 4, n = 2L)

    parameter_type <- parameter_types[type_index]

    parameter_size <- read_unsigned_int(con, cursor + 6, n = 2L)

    cursor_value <- cursor + 8
    n_value <- 2*parameter_size

    if (type_index == 0) {
      parameter_value <- read_signed_int(con, cursor_value, n =  n_value)
    } else if (type_index == 1) {
      parameter_value <- read_double(con, cursor_value, n = n_value)
    } else if (tpye_index %in% c(2,3,4)) {
      parameter_value <- read_character()
    }




    cursor <- cursor + 8 + 2 * parameter_size

    if (cursor >= chunk_size) {
      break
    }

  }

  # browser()

  # ds$value <- value
  # return(ds)
}

#' read chunk method for data
#' @export
parse_chunk.data <- function(ds, con){

  seek(con, where = ds$offset, origin = "start", rw = "read")
  channel_type <- readBin(
    con,
    what = "integer", n = ds$chunk_size, size = 4L, endian = "little"
  )

  ds$value <- value
  return(ds)
}
