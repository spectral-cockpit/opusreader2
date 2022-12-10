prepare_spectra <- function(ds_list, data_param, data_type) {
  NPT <- ds_list[[data_param]]$parameters$NPT$parameter_value
  FXV <- ds_list[[data_param]]$parameters$FXV$parameter_value
  LXV <- ds_list[[data_param]]$parameters$LXV$parameter_value

  wavenumbers <- rev(seq(LXV, FXV, (FXV - LXV) / (NPT - 1L)))

  ds_data <- ds_list[[data_type]]

  ds_data <- c(ds_data, wavenumbers = list(wavenumbers))

  # y-scaling factor
  CSF <- ds_list[[data_param]]$parameters$CSF$parameter_value
  if (!is.null(CSF)) {
    if (CSF != 1L) {
      ds_data$data <- CSF * ds_data$data
    }
  }

  data_matrix <- matrix(ds_data$data[1:NPT], nrow = 1L, ncol = NPT)
  colnames(data_matrix) <- wavenumbers

  ds_data$data <- data_matrix

  class(ds_data) <- "data"

  return(ds_data)
}
