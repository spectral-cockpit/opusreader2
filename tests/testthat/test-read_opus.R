test_that("all test files are parsed without warning", {
  expect_no_warning(read_opus(dsn = "../../inst/extdata/test_data"))
})
