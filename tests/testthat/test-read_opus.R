test_that("all test files are parsed without warnings and errors", {
  expect_no_error(read_opus(dsn = "../../inst/extdata/test_data"))
  expect_no_warning(read_opus(dsn = "../../inst/extdata/test_data"))
})

test_that("all test files are parsed without warnings and errors when
          `data_only = TRUE`", {
  expect_no_error(
    read_opus(dsn = "../../inst/extdata/test_data", data_only = TRUE)
  )
  expect_no_warning(
    read_opus(dsn = "../../inst/extdata/test_data", data_only = TRUE)
  )
})
