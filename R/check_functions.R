check_logical <- function(param) {
  if (!is.logical(param)) {
    param_name <- deparse(substitute(param))
    stop(param_name, " has to be logical (TRUE/FALSE)")
  }
}

check_character <- function(param) {
  if (!is.character(param)) {
    param_name <- deparse(substitute(param))
    stop(param_name, " needs to be a character vector")
  }
}

check_progressr <- function() {
  if (!requireNamespace("progressr", quietly = TRUE)) {
    stop('To use the `progress_bar` option, install {progressr} first.\n
          Use `install.packages("progressr")`', call. = FALSE)
  }
}

check_mirai <- function() {
  if (!requireNamespace("mirai", quietly = TRUE)) {
    stop('To use `.parallel_backend = "mirai"` , install the package: `{mirai}`.\n
          Use `install.package("mirai")`', call. = FALSE)
  }
}
