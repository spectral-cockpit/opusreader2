raw <- read_opus_file("inst/extdata/test_data/629266_1TP A-1_C1.0")

header_data <- read_header(raw)

dataset_list <- lapply(header_data, create_dataset)

dataset_list <- lapply(dataset_list, read_chunk)
