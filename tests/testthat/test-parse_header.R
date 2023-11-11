test_that("header is correctly parsed", {
  raw <- read_opus_raw("../../inst/extdata/test_data/test_spectra.0")

  header_data <- parse_header(raw)

  expect_length(header_data, 20)

  header_data_unlist <- unlist(header_data)

  expect_true(is.integer(header_data_unlist))

  expect_length(header_data_unlist, 140)

  block_type_names <- unique(unlist(lapply(header_data, names)))

  expected_block_type_names <- c(
    "block_type", "channel_type",
    "text_type", "additional_type",
    "offset", "next_offset",
    "chunk_size"
  )

  expect_true(all(block_type_names %in% expected_block_type_names))
})
