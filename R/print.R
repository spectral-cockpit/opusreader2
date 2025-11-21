#' @export
print.list_opusreader2 <- function(x, ...) {
  len <- length(x)
  nm <- if (length(x) != 1) "spectra" else "spectrum"
  cat(paste0("OPUS collection with ", bf(), len, " ", nm, nf(), "\n"))
  utc_times <- unlist(
    lapply(x, function(x) x$basic_metadata$utc_datetime_posixct)
  )
  utc_range <- as.POSIXct(range(utc_times), origin = "1970-01-01", tz = "UTC")
  cat(paste0(bf(), "Measurement metadata:", nf(), "\n"))
  cat(paste0(
    "  * date-time range (UTC): ",
    "[",
    format(utc_range[1]),
    " , ",
    format(utc_range[2]),
    "]",
    "\n"
  ))

  data_names <- unlist(lapply(data, function(x) get_class_names(x, "data")))
  data_tab <- table(data_names)
  param_names <- unlist(lapply(data, function(x) {
    get_class_names(x, "parameter")
  }))
  param_tab <- table(param_names)
  text_names <- unlist(lapply(data, function(x) get_class_names(x, "text")))
  text_tab <- table(text_names)

  cat(
    bf(),
    "* data blocks:\n",
    nf(),
    paste0(
      "  - ",
      names(data_tab),
      " (",
      as.character(unname(data_tab)),
      ")",
      "\n"
    )
  )

  invisible(x)
}

# ANSI bold font terminal start
bf <- function() if (get_ostype() == "unix") "\x1B[1m" else ""

# ANSI normal font terminal start
nf <- function() if (get_ostype() == "unix") "\x1B[22m" else ""

get_ostype <- function() .Platform$OS.type

filter_class <- function(x, class = c("data", "parameter", "text")) {
  cls <- match.arg(class)
  x[vapply(x, function(x) inherits(x, cls), logical(1))]
}

get_class_names <- function(x, class = c("data", "parameter", "text")) {
  x_class <- filter_class(x, class = class)
  names(x_class)
}
