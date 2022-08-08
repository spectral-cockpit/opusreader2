create_dataset <- function(data_list) {
  block_type <- data_list$block_type
  text_type <- data_list$text_type
  channel_type <- data_list$channel_type

  # select read_class and block_type_name
  # TODO: if there is a simpler method, happy to change!
  if (block_type == 0) {
    read_class <- "text"

    if (text_type == 8) {
      read_class <- "parameter"
      block_type_name <- "Info Block"
    } else if (text_type == 104) {
      block_type_name <- "History"
    } else if (text_type == 152) {
      block_type_name <- "Curve Fit"
    } else if (text_type == 168) {
      block_type_name <- "Signature"
    } else if (text_type == 240) {
      block_type_name <- "Integration Method"
    } else {
      block_type_name <- "Text Information"
    }
  } else if (block_type == 7) {
    read_class <- "data"

    if (channel_type == 4) {
      block_type_name <- "ScSm"
    } else if (channel_type == 8) {
      block_type_name <- "IgSm"
    } else if (channel_type == 12) {
      block_type_name <- "PhSm"
    }
  } else if (block_type == 11) {
    read_class <- "data"

    if (channel_type == 4) {
      block_type_name <- "ScRf"
    } else if (channel_type == 8) {
      block_type_name <- "IgRf"
    }
  } else if (block_type == 15) {
    read_class <- "data"
    block_type_name <- "AB"
  } else if (block_type == 23) {
    read_class <- "parameter"

    if (channel_type == 4) {
      block_type_name <- "ScSm Data Parameter"
    } else if (channel_type == 8) {
      block_type_name <- "IgSm Data Parameter"
    } else if (channel_type == 12) {
      block_type_name <- "PhSm Data Parameter"
    }
  } else if (block_type == 27) {
    read_class <- "parameter"

    if (channel_type == 4) {
      block_type_name <- "ScRf Data Parameter"
    } else if (channel_type == 8) {
      block_type_name <- "IgRf Data Parameter"
    }
  } else {
    read_class <- "parameter"

    if (block_type == 31) {
      block_type_name <- "AB Data Parameter"
    } else if (block_type == 32) {
      block_type_name <- "Instrument"
    } else if (block_type == 40) {
      block_type_name <- "Instrument (Rf)"
    } else if (block_type == 48) {
      block_type_name <- "Acquisition"
    } else if (block_type == 56) {
      block_type_name <- "Acquisition (Rf)"
    } else if (block_type == 64) {
      block_type_name <- "Fourier Transformation"
    } else if (block_type == 72) {
      block_type_name <- "Fourier Transformation (Rf)"
    } else if (block_type == 96) {
      block_type_name <- "Optik"
    } else if (block_type == 104) {
      block_type_name <- "Optik (Rf)"
    } else if (block_type == 160) {
      block_type_name <- "Sample"
    } else if (block_type == 176) {
      block_type_name <- "new block"
    } else {
      stop("block not known")
    }
  }

  # create a dataset
  ds <- structure(
    c(data_list, list(block_type_name = block_type_name)),
    class = c("ds", read_class)
  )

  return(ds)
}