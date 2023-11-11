#' Calculate the parameter chunk size in bytes
#' @param ds data set with one of classes `"parameter"`, `"text"` or "`data`"
#' @return Number of bytes as length 1 numeric vector
#' @export
calc_parameter_chunk_size <- function(ds) UseMethod("calc_parameter_chunk_size")

#' @export
calc_parameter_chunk_size.default <- function(ds) {
  return(ds)
}


#' @export
calc_parameter_chunk_size.parameter <- function(ds) {
  ds$chunk_size <- calc_chunk_size(ds)
  return(ds)
}

#' @export
calc_parameter_chunk_size.text <- function(ds) {
  ds$chunk_size <- calc_chunk_size(ds)
  return(ds)
}

#' @export
calc_parameter_chunk_size.data <- function(ds) {
  return(ds)
}

#' calculate the full chunk size
#' @param ds dataset
calc_chunk_size <- function(ds) {
  chunk_size <- ds$next_offset - ds$offset
  return(chunk_size)
}
