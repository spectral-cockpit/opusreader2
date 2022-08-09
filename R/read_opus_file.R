read_opus_file <- function(file) {
  file_size <- file.size(file)
  # Get raw vector
  raw <- readBin(file, "raw", n = file_size)

  header_data <- read_header(raw)
  dataset_list <- lapply(header_data, create_dataset)
  dataset_list <- lapply(dataset_list, read_chunk)
}