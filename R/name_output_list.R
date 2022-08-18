name_output_list <- function(ds_list) {
  block_names <- unlist(lapply(ds_list, function(x) x$block_type_name))
  block_names <- add_spec_no_atm_comp(block_names)
  block_names <- add_lab_process_name(block_names)
  names(ds_list) <- block_names

  return(ds_list)
}

add_spec_no_atm_comp <- function(x) {
  i <- which(grepl("spec$", x))
  j <- which(grepl("spec_data_param", x))

  if (length(i) == 1) {
    return(x)
  }

  x[i[1]] <- "spec_no_atm_comp"
  x[j[1]] <- "spec_no_atm_comp_data_param"

  return(x)
}

add_lab_process_name <- function(x){

  i <- which(grepl("lab_and_", x))

  z <- 1

  if(length(i) > 1){
    for (j in i) {

      x[j] <- paste0("lab_and_process_param_", z)
      z <- z+1

    }
  }

  return(x)
}
