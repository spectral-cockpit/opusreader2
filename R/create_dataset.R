#' assign the classes to the dataset list
#' @param header_data list of the header information for each block
#' @keywords internal
create_dataset <- function(header_data) {
  block_type <- as.character(header_data$block_type)
  text_type <- as.character(header_data$text_type)
  channel_type <- as.character(header_data$channel_type)
  additional_type <- as.character(header_data$additional_type)

  # define compoosite key for chunk
  composite_key <- paste(
    paste0("b", block_type), paste0("c", channel_type),
    paste0("t", text_type), paste0("a", additional_type),
    sep = "-"
  )

  # nolint start

  # keys ("<block>-<text>-<channel>-<additional_type>") :
  # values (read_class, block_type_name)
  # general mapping rules for codes (keys):
  #   - additional type = 64 => default, no macro processing
  #   - additional type = 0  => extra processing, found atmospheric compensation
  key_value_map <- list(
    # block code 0, channel code 0 ------------------------------------------------------------
    # additional information and/or OPUS processing macros
    "b0-c0-t0-a(0|64)" = c(read_class = "text", block_type_name = "text_information"),
    "b0-c0-t8-a0" = c(read_class = "parameter", block_type_name = "info_block"),
    "b0-c0-t104-a64" = c(read_class = "text", block_type_name = "history"),
    "b0-c0-t144-a1" = c(read_class = "parameter", block_type_name = "report_unknown"),
    "b0-c0-t152-a(0|64)" = c(read_class = "text", block_type_name = "curve_fit"),
    "b0-c0-t168-a(0|64)" = c(read_class = "text", block_type_name = "signature"),
    "b0-c0-t240-a(0|64)" = c(read_class = "text", block_type_name = "integration_method"),
    # guess general text

    # block code 7 -----------------------------------------------------------------------------
    # spectrum types of sample
    "b7-c4-t0-a(0|64)" = c(read_class = "data", block_type_name = "sc_sample"),
    "b7-c8-t0-a(0|64)" = c(read_class = "data", block_type_name = "ig_sample"),
    "b7-c12-t0-a(0|64)" = c(read_class = "data", block_type_name = "ph_sample"),

    # block code 11 ----------------------------------------------------------------------------
    # spectrum types of reference (background)
    "b11-c4-t0-a(0|64)" = c(read_class = "data", block_type_name = "sc_ref"),
    "b11-c8-t0-a(0|64)" = c(read_class = "data", block_type_name = "ig_ref"),
    "b11-c12-t0-a(0|64)" = c(read_class = "data", block_type_name = "ph_ref"),
    # block code 15 -----------------------------------------------------------------------------
    # spectrum report blocs
    # channel code 15: save (apparent) absorbance
    "b15-c16-t112-a0" = c(read_class = "parameter", block_type_name = "quant_report_ab"),
    "b15-c16-t104-a1" = c(read_class = "parameter", block_type_name = "me_test_report_ab"),
    "b15-c16-t0-a64" = c(read_class = "data", block_type_name = "ab_no_atm_comp"),
    "b15-c16-t0-a0" = c(read_class = "data", block_type_name = "ab"),
    # https://github.com/spectral-cockpit/opusreader2/issues/81
    "b15-c16-t96-a0" = c(read_class = "parameter", block_type_name = "quality_test_report"),
    # channel code 48: save reflectance (settings
    "b15-c48-t112-a0" = c(read_class = "parameter", block_type_name = "quant_report_refl"),
    "b15-c48-t104-a1" = c(read_class = "parameter", block_type_name = "me_test_report_refl"), # check "a1"
    "b15-c48-t0-a64" = c(read_class = "data", block_type_name = "refl_no_atm_comp"),
    "b15-c48-t0-a0" = c(read_class = "data", block_type_name = "refl"),
    # channel code 88 and 216: spectra matching
    "b15-c88-t0-a(0|64)" = c(read_class = "data", block_type_name = "match"),
    "b15-c216-t0-a(0|64)" = c(read_class = "data", block_type_name = "match_2_chn"),

    # block code 23 -----------------------------------------------------------------------------
    # data parameters (metadata) for spectrum types of sample
    "b23-c4-t0-a(0|64)" = c(read_class = "parameter", block_type_name = "sc_sample_data_param"),
    "b23-c8-t0-a(0|64)" = c(read_class = "parameter", block_type_name = "ig_sample_data_param"),
    "b23-c12-t0-a(0|64)" = c(read_class = "parameter", block_type_name = "ph_sample_data_param"),

    # block code 27 -----------------------------------------------------------------------------
    # data parameters (metadata) for spectrum types of reference (background)
    "b27-c4-t0-a(0|64)" = c(read_class = "parameter", block_type_name = "sc_ref_data_param"),
    "b27-c8-t0-a(0|64)" = c(read_class = "parameter", block_type_name = "ig_ref_data_param"),
    "b27-c12-t0-a(0|64)" = c(read_class = "parameter", block_type_name = "ph_ref_data_param"),

    # block code 31 -----------------------------------------------------------------------------
    # data parameters (metadata) when spectra (normalized single channels) saved in apparent absorbance
    "b31-c16-t0-a64" = c(read_class = "parameter", block_type_name = "ab_no_atm_comp_data_param"),
    "b31-c16-t0-a0" = c(read_class = "parameter", block_type_name = "ab_data_param"),

    # data parameters (metadata) when spectra (normalized single channels) saved in reflectance
    "b31-c48-t0-a64" = c(read_class = "parameter", block_type_name = "refl_no_atm_comp_data_param"),
    "b31-c48-t0-a0" = c(read_class = "parameter", block_type_name = "refl_data_param"),

    # data parameters (metadata) for spectra matching
    "b31-c88-t0-a(0|64)" = c(read_class = "parameter", block_type_name = "match_data_param"),
    "b31-c216-t0-a(0|64)" = c(read_class = "parameter", block_type_name = "match_2_chn_data_param"),

    ## General metadata blocks

    # block code 32 -----------------------------------------------------------------------------
    "b32-c0-t0-a(0|64)" = c(read_class = "parameter", block_type_name = "instrument"),

    # block code 40 -----------------------------------------------------------------------------
    "b40-c0-t0-a(0|64)" = c(read_class = "parameter", block_type_name = "instrument_ref"),

    # block code 48 -----------------------------------------------------------------------------
    "b48-c0-t0-a(0|64)" = c(read_class = "parameter", block_type_name = "acquisition"),

    # block code 56 -----------------------------------------------------------------------------
    "b56-c0-t0-a(0|64)" = c(read_class = "parameter", block_type_name = "acquisition_ref"),

    # block code 64 -----------------------------------------------------------------------------
    "b64-c0-t0-a(0|64)" = c(read_class = "parameter", block_type_name = "fourier_transformation"),

    # block code 72 -----------------------------------------------------------------------------
    "b72-c0-t0-a(0|64)" = c(read_class = "parameter", block_type_name = "fourier_transformation_ref"),

    # block code 96 -----------------------------------------------------------------------------
    "b96-c0-t0-a(0|64)" = c(read_class = "parameter", block_type_name = "optics"),

    # block code 104 -----------------------------------------------------------------------------
    "b104-c0-t0-a(0|64)" = c(read_class = "parameter", block_type_name = "optics_ref"),

    # block code 160 -----------------------------------------------------------------------------
    "b160-c0-t0-a(0|64)" = c(read_class = "parameter", block_type_name = "sample"),

    # block code 176 -----------------------------------------------------------------------------
    "b176-c0-t0-a64" = c(read_class = "parameter", block_type_name = "lab_and_process_param_raw"),
    "b176-c0-t0-a0" = c(read_class = "parameter", block_type_name = "lab_and_process_param_processed")
  )

  # nolint end

  # check key names for matching composite key
  key_names <- names(key_value_map)
  is_match <- unlist(lapply(key_names, function(pat) grepl(pat, composite_key)))
  key_value_match <- key_value_map[is_match]
  nm_matches <- names(key_value_match)

  if (length(key_value_match) != 0L) {
    key_value_match_vec <- key_value_match[[1]]
    read_class <- unname(key_value_match_vec["read_class"])
    block_type_name <- unname(key_value_match_vec["block_type_name"])
  } else if (length(key_value_match) == 0L) {
    # inform about details and what to do for improving {opusreader2}
    read_class <- NULL

    block_type_name <- "unknown"

    warn_proactively(composite_key)
  }


  # create a dataset
  ds <- structure(
    c(header_data, list(block_type_name = block_type_name)),
    class = c(read_class)
  )

  return(ds)
}

warn_proactively <- function(composite_key) {
  warning(
    paste(
      "Unknown header entry.\n The following 'composite key' is not yet",
      "mapped in the {opusreader2} key-value map of the header:\n",
      "*", paste0('"', composite_key, '"'), "\nWe encourage your contribution",
      "to feature this new OPUS block by opening a new issue on
     https://github.com/spectral-cockpit/opusreader2/issues",
      "\nPlease\n",
      "1. report reproducibly, using short code with {opusreader2}
      (recommended: https://reprex.tidyverse.org)", "\n",
      "2. describe briefly\n",
      "  a) Bruker instrument used\n",
      "  b) equipment\n",
      "  c) measurement mode and spectral blocks saved (OPUS settings)\n",
      "  d) OPUS software version\n",
      "  e) your general workflow for spectroscopic diagnostics\n",
      "3. provide an example OPUS binary file uploaded for public access\n",
      "   on GitHub (best in issue)\n",
      "4. to facilitate widespread support of Bruker devices in open source\n",
      "   based infrastructure, show the data blocks as print screens in the\n",
      "   Bruker OPUS software (right-click in Viewer). Please upload the\n",
      "   contents of all OPUS blocks in individual screenshots."
    ),
    call. = FALSE
  )
}
