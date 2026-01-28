prepare_spectra <- function(ds_list, data_type) {
  data_pattern <- paste0(data_type, "$")
  # block names containing "ab" can also be class "parameters", rather than
  # "data" required (e.g., "quant_report_ab", "me_test_report_ab")
  pat_match <- grepl(data_pattern, names(ds_list))
  data_class <- vapply(ds_list, function(x) inherits(x, "data"), logical(1))
  data_match <- pat_match & data_class

  index <- which(data_match)

  ds_data <- ds_list[data_match]
  ds_param <- ds_list[grepl(paste0(data_type, "_data_param"), names(ds_list))]

  NPT <- ds_param[[1]]$parameters$NPT$parameter_value
  FXV <- ds_param[[1]]$parameters$FXV$parameter_value
  LXV <- ds_param[[1]]$parameters$LXV$parameter_value

  wavenumbers <- rev(seq(LXV, FXV, (FXV - LXV) / (NPT - 1)))

  ds_data[[1]] <- c(ds_data[[1]], wavenumbers = list(wavenumbers))

  # y-scaling factor
  CSF <- ds_param[[1]]$parameters$CSF$parameter_value
  if (!is.null(CSF) && CSF != 1) {
    ds_data[[1]]$data <- CSF * ds_data[[1]]$data
  }

  data_matrix <- matrix(ds_data[[1]]$data[1:NPT], nrow = 1, ncol = NPT)
  colnames(data_matrix) <- wavenumbers

  ds_data[[1]]$data <- data_matrix

  class(ds_data[[1]]) <- "data"

  ds_list[[index]] <- ds_data[[1]]

  return(ds_list)
}


get_data_types <- function(ds_list) {
  block_names <- names(ds_list)
  data_types <- block_names[grepl("sc|ig|ph|^ab|^refl|^match", block_names)]
  data_types <- unique(gsub("_data_param", "", data_types, fixed = TRUE))

  return(data_types)
}
