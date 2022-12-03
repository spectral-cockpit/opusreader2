name_output_list <- function(ds_list) {
  block_names <- unlist(lapply(ds_list, function(x) x$block_type_name))
  names(ds_list) <- block_names

  return(ds_list)
}
