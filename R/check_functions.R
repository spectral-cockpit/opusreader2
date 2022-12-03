check_logical <- function(param) {
  if (!is.logical(param)) {
    param_name <- deparse(substitute(param))
    stop(paste0(param_name, " has to be logical (TRUE/FALSE)"))
  }
}

check_character <- function(param) {
  if (!is.character(param)) {
    param_name <- deparse(substitute(param))
    stop(paste0(param_name, " needs to be a character vector"))
  }
}

check_future <- function() {
  if (!require("future") ) {
    stop('To use the parallel option, install the package: future, first.\n
           Use `install.package("future")`')
  }
  if (!require("future.apply") ) {
    stop('To use the parallel option, install the package: future.apply, first.\n
           Use `install.package("future.apply")`')
  }
}
