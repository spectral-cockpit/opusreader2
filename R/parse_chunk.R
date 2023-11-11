#' read chunk method
#'
#' @param ds chunk dataset
#'
#' @param raw raw vector
#'
#' @keywords internal
#' @family parsing
parse_chunk <- function(ds,raw) UseMethod("parse_chunk")



#' read chunk method for default
#'
#' @inheritParams parse_chunk
#'
#' @keywords internal
parse_chunk.default <- function(ds,raw) {

  return(ds)
}


#' read chunk method for text
#'
#' @inheritParams parse_chunk
#'
#' @keywords internal
parse_chunk.text <- function(ds,raw) {

  text <- read_character(raw, ds$offset+1, n = ds$chunk_size, n_char = ds$chunk_size)

  ds$text <- text
  return(ds)
}

#' read chunk method for parameter
#'
#' @inheritParams parse_chunk
#'
#' @keywords internal
parse_chunk.parameter <- function(ds,raw) {

  if (ds$text_type %in% c(104, 112, 144)) {
    cursor <- ds$offset + 13
  } else {
    cursor <- ds$offset + 1
  }

  chunk_size <- ds$chunk_size

  parameter_types <- c("int", "float", "str", "str", "str")

  result_list <- list()

  repeat {

    parameter_name <- read_character(raw, cursor, n = 1, n_char = 3)

    if (parameter_name == "END") {
      break
    }

    nice_parameter_name <- get_nice_parameter_name(parameter_name)

    # need to add since index that is returned starts with 0;
    # R index starts at 1
    type_index <- read_unsigned_int(raw, cursor + 4, n = 1L) + 1

    parameter_type <- parameter_types[type_index]

    parameter_size <- read_unsigned_int(raw, cursor + 6, n = 1L)

    cursor_value <- cursor + 8


    if (type_index == 1) {
      parameter_value <- read_signed_int(raw, cursor_value, n = 1L)
    } else if (type_index == 2) {
      parameter_value <- read_double(raw, cursor_value, n = 1L)
    } else if (type_index %in% c(3, 4, 5)) {
      parameter_value <- read_character(raw, cursor_value, n = 1L, n_char = parameter_size)
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
#' @keywords internal
parse_chunk.data <- function(ds, raw) {

  data <- read_float(raw, ds$offset+1, n = ds$chunk_size)

  ds$data <- data
  return(ds)
}
