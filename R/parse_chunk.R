#' read chunk method
#'
#' @param ds chunk dataset
#'
#' @param con connection to raw vector
#'
#' @export
parse_chunk <- function(ds, con) UseMethod("parse_chunk")

#' read chunk method for text
#'
#' @inheritParams parse_chunk
#'
#' @export
parse_chunk.text <- function(ds, con) {
  text <- read_character(con, ds$offset, n = ds$chunk_size)

  ds$text <- text
  return(ds)
}

#' read chunk method for parameter
#'
#' @inheritParams parse_chunk
#'
#' @export
parse_chunk.parameter <- function(ds, con) {
  if (ds$text_type == 112) {
    cursor <- ds$offset + 12
  } else {
    cursor <- ds$offset
  }

  chunk_size <- ds$chunk_size

  parameter_types <- c("int", "float", "str", "str", "str")

  result_list <- list()

  repeat {
    parameter_name <- read_character(con, cursor, n = 1L)

    if (parameter_name == "END") {
      break
    }

    nice_parameter_name <- get_nice_parameter_name(parameter_name)

    # need to add since index that is returned starts with 0;
    # R index starts at 1
    type_index <- read_unsigned_int(con, cursor + 4, n = 1L) + 1

    parameter_type <- parameter_types[type_index]

    parameter_size <- read_unsigned_int(con, cursor + 6, n = 1L)

    cursor_value <- cursor + 8


    if (type_index == 1) {
      parameter_value <- read_signed_int(con, cursor_value, n = 1L)
    } else if (type_index == 2) {
      parameter_value <- read_double(con, cursor_value, n = 1L)
    } else if (type_index %in% c(3, 4, 5)) {
      parameter_value <- read_character(con, cursor_value, n = 1L)
    }

    repeat_list <- list(
      parameter_name = parameter_name,
      parameter_name_long = nice_parameter_name,
      parameter_value = parameter_value,
      parameter_type = parameter_type
    )

    result_list <- c(result_list, list(repeat_list))


    cursor <- cursor + 8 + 2 * parameter_size

    if (cursor >= ds$offset + chunk_size) {
      break
    }
  }

  parameter_names <- unlist(lapply(result_list, function(x) x$parameter_name))

  names(result_list) <- parameter_names

  ds$parameters <- result_list
  return(ds)
}

#' read chunk method for data
#'
#' @inheritParams parse_chunk
#'
#' @export
parse_chunk.data <- function(ds, con) {
  data <- read_float(con, ds$offset, n = ds$chunk_size)

  ds$data <- data
  return(ds)
}
