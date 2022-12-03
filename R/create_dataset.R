#' assign the classes to the dataset list
#' @param data_list list of the header information for each block
create_dataset <- function(data_list) {
  block_type <- data_list$block_type
  text_type <- data_list$text_type
  channel_type <- data_list$channel_type
  additional_type <- data_list$additional_type

  # select read_class and block_type_name
  # TODO: if there is a simpler method, happy to change!
  if (block_type == 0) {
    read_class <- "text"


    if (text_type == 8) {
      read_class <- "parameter"
      block_type_name <- "info_block"
    } else if (text_type == 104) {
      block_type_name <- "history"
    } else if (text_type == 152) {
      block_type_name <- "curve_fit"
    } else if (text_type == 168) {
      block_type_name <- "signature"
    } else if (text_type == 240) {
      block_type_name <- "integration_method"
    } else {
      block_type_name <- "text_information"
    }
  } else if (block_type == 7) {
    read_class <- "data"

    if (channel_type == 4) {
      block_type_name <- "sc_sample"
    } else if (channel_type == 8) {
      block_type_name <- "ig_sample"
    } else if (channel_type == 12) {
      block_type_name <- "ph_sample"
    }
  } else if (block_type == 11) {
    read_class <- "data"

    if (channel_type == 4) {
      block_type_name <- "sc_ref"
    } else if (channel_type == 8) {
      block_type_name <- "ig_ref"
    } else {
      stop("There is a new block type, open an issue.")
    }
  } else if (block_type == 15) {
    if (channel_type == 16) {
      if (text_type == 112) {
        read_class <- "parameter"
        block_type_name <- "quant_report_ab"
      } else if (text_type == 104) {
        read_class <- "parameter"
        block_type_name <- "me_test_report_ab"
      } else {
        read_class <- "data"
        if (additional_type == 64) {
          block_type_name <- "ab_no_atm_comp"
        } else if (additional_type == 0) {
          block_type_name <- "ab"
        } else {
          stop("There is a new block type, open an issue.")
        }
      }
    } else if (channel_type == 48) {
      if (text_type == 112) {
        read_class <- "parameter"
        block_type_name <- "quant_report_refl"
      } else if (text_type == 104) {
        read_class <- "parameter"
        block_type_name <- "me_test_report_refl"
      } else {
        read_class <- "data"
        if (additional_type == 64) {
          block_type_name <- "refl_no_atm_comp"
        } else if (additional_type == 0) {
          block_type_name <- "refl"
        } else {
          stop("There is a new block type, open an issue.")
        }
      }
    } else if (channel_type == 88) {
      read_class <- "data"
      block_type_name <- "match"
    } else if (channel_type == 216) {
      read_class <- "data"
      block_type_name <- "match_2_chn"
    } else {
      stop("There is a new block type, open an issue.")
    }
  } else if (block_type == 23) {
    read_class <- "parameter"

    if (channel_type == 4) {
      block_type_name <- "sc_sample_data_param"
    } else if (channel_type == 8) {
      block_type_name <- "ig_sample_data_param"
    } else if (channel_type == 12) {
      block_type_name <- "ph_sample_data_param"
    } else {
      stop("There is a new block type, open an issue.")
    }
  } else if (block_type == 27) {
    read_class <- "parameter"

    if (channel_type == 4) {
      block_type_name <- "sc_ref_data_param"
    } else if (channel_type == 8) {
      block_type_name <- "ig_ref_data_param"
    } else {
      stop("There is a new block type, open an issue.")
    }
  } else {
    read_class <- "parameter"

    if (block_type == 31) {
      if (channel_type == 16) {
        if (additional_type == 64) {
          block_type_name <- "ab_no_atm_comp_data_param"
        } else if (additional_type == 0) {
          block_type_name <- "ab_data_param"
        } else {
          stop("There is a new block type, open an issue.")
        }
      } else if (channel_type == 48) {
        if (additional_type == 64) {
          block_type_name <- "refl_no_atm_comp_data_param"
        } else if (additional_type == 0) {
          block_type_name <- "refl_data_param"
        } else {
          stop("There is a new block type, open an issue.")
        }
      } else if (channel_type == 88) {
        block_type_name <- "match_data_param"
      } else if (channel_type == 216) {
        block_type_name <- "match_2_chn_data_param"
      } else {
        stop("There is a new block type, open an issue.")
      }
    } else if (block_type == 32) {
      block_type_name <- "instrument"
    } else if (block_type == 40) {
      block_type_name <- "instrument_ref"
    } else if (block_type == 48) {
      block_type_name <- "acquisition"
    } else if (block_type == 56) {
      block_type_name <- "acquisition_ref"
    } else if (block_type == 64) {
      block_type_name <- "fourier_transformation"
    } else if (block_type == 72) {
      block_type_name <- "fourier_transformation_ref"
    } else if (block_type == 96) {
      block_type_name <- "optics"
    } else if (block_type == 104) {
      block_type_name <- "optics_ref"
    } else if (block_type == 160) {
      block_type_name <- "sample"
    } else if (block_type == 176) {
      if (additional_type == 64) {
        block_type_name <- "lab_and_process_param_raw"
      } else if (additional_type == 0) {
        block_type_name <- "lab_and_process_param_processed"
      } else {
        stop("There is a new block type, open an issue.")
      }
    } else {
      stop("block not known")
    }
  }

  # create a dataset
  ds <- structure(
    c(data_list, list(block_type_name = block_type_name)),
    class = c(read_class)
  )

  return(ds)
}
