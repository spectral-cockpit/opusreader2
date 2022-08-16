#' read opus file
#'
#' @param file file path to opus file
#'
#' @export
read_opus_file <- function(file) {
  file_size <- file.size(file)
  # Get raw vector
  raw <- readBin(file, "raw", n = file_size)

  con <- rawConnection(raw)

  header_data <- parse_header(raw, con)

  dataset_list <- lapply(header_data, create_dataset)

  dataset_list <- lapply(dataset_list, calc_parameter_chunk_size)

  dataset_list <- lapply(dataset_list, function(x) parse_chunk(x, con))

  dataset_list <- name_output_list(dataset_list)

  data_types <- get_data_types(dataset_list)

  dataset_list <- Reduce(
    function(x, y) calculate_wavenumbers(x, y),
    x = data_types, init = dataset_list
  )

  dataset_list <- sort_list_by(dataset_list)

  on.exit(close(con))

  return(dataset_list)
}
