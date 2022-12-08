prepare_spectra <- function(ds_list, data_type) {
  data_pattern <- paste0(data_type, "$")

  ds_data <- ds_list[grepl(data_pattern, names(ds_list))]
  ds_param <- ds_list[grepl(paste0(data_type, "_data_param"), names(ds_list))]

  index <- which(grepl(data_pattern, names(ds_list)))

  NPT <- ds_param[[1]]$parameters$NPT$parameter_value
  FXV <- ds_param[[1]]$parameters$FXV$parameter_value
  LXV <- ds_param[[1]]$parameters$LXV$parameter_value

  wavenumbers <- rev(seq(LXV, FXV, (FXV - LXV) / (NPT - 1L)))

  names_first <- names(ds_data[[1]])
  ds_data[[1]] <- append(ds_data[[1]], values = wavenumbers)
  names(ds_meta[[1]]) <- c(names_first, "wavenumbers")

  # y-scaling factor
  CSF <- ds_param[[1]]$parameters$CSF$parameter_value
  if (!is.null(CSF)) {
    if (CSF != 1L) {
      ds_data[[1]]$data <- CSF * ds_data[[1]]$data
    }
  }

  data_matrix <- matrix(ds_data[[1]]$data[1:NPT], nrow = 1L, ncol = NPT)
  colnames(data_matrix) <- wavenumbers

  ds_data[[1]]$data <- data_matrix

  class(ds_data[[1]]) <- "data"

  ds_list[[index]] <- ds_data[[1]]

  return(ds_list)
}



get_data_types <- function(ds_list) {
  block_names <- names(ds_list)
  data_types <- block_names[grepl("sc|ig|ph|^ab|^refl", block_names)]
  data_types <- unique(gsub("_data_param", "", data_types))

  return(data_types)
}
