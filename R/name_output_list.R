name_output_list <- function(ds_list) {
  block_names <- unlist(lapply(ds_list, function(x) x$block_type_name))
  block_names <- add_spec_no_atm_comp(block_names)
  names(ds_list) <- block_names

  return(ds_list)
}

add_spec_no_atm_comp <- function(x) {
  i <- which(grepl("spec$", x))
  j <- which(grepl("spec_data_param", x))

  if (length(i) == 1) {
    return(x)
  }

  x[head(i, 1)] <- "spec_no_atm_comp"
  x[head(j, 1)] <- "spec_no_atm_comp_data_param"

  return(x)
}