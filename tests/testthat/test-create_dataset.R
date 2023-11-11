test_that("that a dataset is correctly cearted", {

  header_data <- list(
    block_type = 0,
    text_type = 104,
    channel_type  = 0,
    additional_type = 64
  )

  ds <- create_dataset(header_data)

  expect_equal(ds$block_type_name, "history")

  expect_true(inherits(ds, "text"))


  header_data <- list(
    block_type = 100,
    text_type = 104,
    channel_type  = 0,
    additional_type = 64
  )


  expect_warning(
    create_dataset(header_data),
    regexp = "Unknown header entry"
  )

  ds <- suppressWarnings(create_dataset(header_data))

  expect_equal(ds$block_type_name, "unknown")

  expect_true(inherits(ds, "list"))


  header_data <- list(
    block_type = 15,
    text_type = 0,
    channel_type  = 48,
    additional_type = 64
  )

  ds <- create_dataset(header_data)

  expect_equal(ds$block_type_name, "refl_no_atm_comp")


})
