#' Print method for collection of OPUS spectra with class `list_opusreader2`
#'
#' @param x List with OPUS spectra collection of class `list_opusreader2`
#' @param ... Additional arguments passed to print method
#' @return Returns `x` invisibly.
#' @export
print.list_opusreader2 <- function(x, ...) {
  len <- length(x)
  nm <- if (length(x) != 1) "spectra" else "spectrum"
  cat_startblock()
  cat_opuscollection(len, nm)
  cat_endblock()
  utc_times <- unlist(
    lapply(x, function(x) x$basic_metadata$utc_datetime_posixct)
  )
  utc_range <- as.POSIXct(range(utc_times), origin = "1970-01-01", tz = "UTC")
  cat(paste0(bf(), "Measurement metadata:", nf(), "\n"))
  cat(paste0(
    "* date-time range (UTC): ",
    "[",
    format(utc_range[1]),
    " , ",
    format(utc_range[2]),
    "]",
    "\n"
  ))

  data_names <- unlist(lapply(x, function(x) get_class_names(x, "data")))
  data_tab <- table(data_names)
  param_names <- unlist(lapply(x, function(x) {
    get_class_names(x, "parameter")
  }))
  param_tab <- table(param_names)
  text_names <- unlist(lapply(x, function(x) get_class_names(x, "text")))
  text_tab <- table(text_names)

  cat_block_types(
    table = data_tab,
    block_info = "* data blocks",
    enum_char = "",
    linesep = ";",
    fill = getOption("width")
  )

  cat_block_types(
    table = param_tab,
    block_info = "* parameter blocks",
    enum_char = "",
    linesep = ";",
    fill = getOption("width")
  )

  invisible(x)
}

cat_block_types <- function(
  table,
  block_info = " * data blocks",
  enum_char = ";",
  linesep = "\n",
  fill = FALSE
) {
  cat(
    bf(),
    get_padded_text(paste0(block_info, " (#spectra) ")),
    nf(),
    paste0(
      " ",
      enum_char,
      " ",
      names(table),
      " (",
      as.character(unname(table)),
      ")",
      linesep
    ),
    fill = fill
  )
}

cat_startblock <- function(width = getOption("width")) {
  cat(
    get_padded_text_lr(
      text = "",
      width = width,
      left_border = rawToChar(as.raw(c(0xe2, 0x95, 0x94))),
      right_border = rawToChar(as.raw(c(0xe2, 0x95, 0x97))),
      fill_char = "="
    ),
    "\n"
  )
}

cat_opuscollection <- function(len, nm) {
  cat(
    get_padded_text_lr(
      text = paste0("OPUS collection with ", bf(), len, " ", nm, nf()),
      width = getOption("width"),
      left_border = "",
      right_border = "",
      fill_char = " "
    ),
    "\n"
  )
}

cat_endblock <- function(width = getOption("width")) {
  cat(
    get_padded_text_lr(
      text = "",
      width = width,
      left_border = rawToChar(as.raw(c(0xe2, 0x95, 0x9a))),
      right_border = rawToChar(as.raw(c(0xe2, 0x95, 0x9d))),
      fill_char = "="
    ),
    "\n"
  )
}

get_padded_text <- function(text, width = getOption("width"), pad_char = "-") {
  pad_len <- width - nchar(text)
  padding <- if (pad_len > 0) {
    paste0(rep(pad_char, pad_len), collapse = "")
  } else {
    ""
  }
  padded_string <- paste0(text, padding)
  return(padded_string)
}


get_padded_text_lr <- function(
  text,
  width = getOption("width"),
  left_border = rawToChar(as.raw(c(0xe2, 0x95, 0x91))),
  right_border = rawToChar(as.raw(c(0xe2, 0x95, 0x91))),
  fill_char = " "
) {
  text_len <- nchar(text, type = "width") # counts display width

  total_pad_len <- width - text_len - nchar(left_border) - nchar(right_border)
  if (total_pad_len < 0) {
    total_pad_len <- 0
  }

  left_pad_len <- ceiling(total_pad_len / 2)
  right_pad_len <- ceiling(total_pad_len / 2)
  left_padding <- strrep(fill_char, left_pad_len)
  right_padding <- strrep(fill_char, right_pad_len)

  padded_string <- paste0(
    left_border,
    left_padding,
    text,
    right_padding,
    right_border
  )
  return(padded_string)
}


cat_pad <- function(text, width = getOption("width"), pad_char = "=") {
  padded_string <- get_padded_text(text, width, pad_char)
  cat(padded_string, "\n")
}


#' Concatenate list of column vectors to lines using a simple multicolumn
#' layout.
#'
#' @param cols list of character elements with identical lenghts equal to number
#' of lines to be printed.
#' @noRd
cat_multicol_lines <- function(cols, widths = NULL) {
  ncols <- length(cols)
  if (is.null(widths)) {
    widths <- rep(15, ncols) # default width for all columns
  }
  if (length(widths) != ncols) {
    stop("Lengths of cols and widths must match")
  }

  # Create the format string, each column left-aligned with specified width
  fmt <- paste0(paste0("%-", widths, "s"), collapse = " ")
  fmt <- paste0(fmt, "\n")

  rows <- do.call(sprintf, c(fmt, cols))
  cat(rows, sep = "")
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
