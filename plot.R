#' Plot spectra read from OPUS files
#'
#' @param data list of class "opusreader2" (single OPUS file) or both
#' "opusreader2" and "list_opusreader2", containing spectral data parsed from
#' Bruker OPUS binary files.
#' @param data_type character vector of length one with desired spectral data
#' type to plot.
#' @param plot_type plot type, either `"base"``, printing a base plot, or
#' `"ggplot2"``, which returns a ggplot2 object.
#' @family core
#' @return a base R plot with spectra
#'
#' @export
plot <- function(data,
                 data_type = c(
                   "ref_no_atm_comp", "refl",
                   "ab_no_atm_comp", "ab",
                   "sc_sample", "ig_sample",
                   "sc_ref", "ig_ref"
                 ),
                 plot_type = c("base", "ggplot2")) {
  UseMethod("plot")
}


plot.opusreader2 <- function(data, data_type, plot_type) {
  stopifnot(
    "`data` must be either class 'opusreader2_list' or 'opusreader2'" = 
      class(data) %in% c("list_opusreader2", "opusreader2")
  )

  data_type <- match.arg(data_type)
  plot_type <- match.arg(plot_type)

  validate_plot(data, data_type, plot_type)

  # get the spectra (y) and x (x-axis; e.g. wavenumber)
  if (inherits(data, "list_opusreader2")) {
    spectra <- do.call(
      rbind,
      Map(function(x) x[[y]], x = data, y = data_type)
    )
  } else {
    spectra <- data[[data_type]]
  }

  ylab <- switch(
    EXPR = data_type,
    "ref_no_atm_comp" = "Reflectance (no atm. comp.)",
    "refl" = "Reflectance",
    "ab_no_atm_comp" = "Absorbance (no atm. comp.)",
    "ab" = "Absorbance",
    "sc_sample" = "Single channel sample",
    "ig_sample" = "Interferogram sample",
    "sc_ref" = "Single channel reference",
    "ig_ref" = "Interferogram sample"
  )

  matplot(
    x = x,
    y = t(spectra),
    type = "l",
    lwd = 1.5,
    xlab = xlab,
    ylab = ylab
  )
}

validate_plot <- function(data, data_type, plot_type) {
  stopifnot(
    inherits(data, "opusreader2")
  )
  validate_plot_data_type(data, data_type)
}

validate_plot_data_type <- function(data, data_type, plot_type) {
  if (inherits(data, "list_opusreader2")) {
    all_data_types <- all(
      unlist(lapply(data, function(x) data_type %in% names(x)))
    )
  } else {
    all_data_types <- data_type %in% names(data)
  }

  if (!isTRUE(all_data_types)) {
    stop("All `data` elements need to contain `data_type`",
      paste0(data_type, "."),
      call. = FALSE
    )
  }
  invisible(all_data_types)
}
