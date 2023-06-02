get_meta_sample_name <- function(ds_list) {
  ds_parameter <- ds_list[vapply(ds_list, class,
    FUN.VALUE = character(1L)
  ) == "parameter"]

  sample <- ds_parameter$sample
  sample_name_long <- sample$parameters$SNM$parameter_value
  sample_name <- strsplit(sample_name_long, split = ";")[[1L]][1L]
  return(sample_name)
}
