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
  if (!requireNamespace("future")) {
    stop('To use the parallel option, install the package: future, first.\n
          Use `install.package("future")`')
  }
  if (!requireNamespace("future.apply")) {
    stop(
      "To use the parallel option, install the package: future.apply,",
      'first.\n Use `install.packages("future.apply")`',
      call. = FALSE
    )
  }
}

check_progressr <- function() {
  if (!requireNamespace("progressr")) {
    stop('To use the `progress_bar` option, install {progressr} first.\n
          Use `install.packages("progressr")`', call. = FALSE)
  }
}
