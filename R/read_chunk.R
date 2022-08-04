#' read chunk method
#' @export
read_chunk <- function(ds, con) UseMethod("read_chunk")

#' read chunk method for text
#' @export
read_chunk.text <- function(ds, con){


  # ds$value <- value
  # return(ds)
}

#' read chunk method for parameter
#' @export
read_chunk.parameter <- function(ds, con){
  browser()

  # ds$value <- value
  # return(ds)
}

#' read chunk method for data
#' @export
read_chunk.data <- function(ds, con){


  # ds$value <- value
  # return(ds)
}
