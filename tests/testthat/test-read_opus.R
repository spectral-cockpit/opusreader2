test_that("all test files are parsed without warnings and errors", {
  expect_no_error(read_opus(dsn = opus_test_dsn()))
  expect_no_warning(read_opus(dsn = opus_test_dsn()))
})

test_that("all test files are parsed without warnings and errors when
          `data_only = TRUE`", {
  expect_no_error(
    read_opus(dsn = opus_test_dsn(), data_only = TRUE)
  )
  expect_no_warning(
    read_opus(dsn = opus_test_dsn(), data_only = TRUE)
  )
})
