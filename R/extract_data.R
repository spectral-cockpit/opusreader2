extract_blocks <- function(dataset_list, filter_vector) {
  dataset_list <- dataset_list[
    lapply(
      dataset_list,
      function(x) x$block_type_name
    ) %in%
      c(filter_vector)
  ]

  return(dataset_list)
}
