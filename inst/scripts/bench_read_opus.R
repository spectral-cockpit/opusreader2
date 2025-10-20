library("opusreader2")

file <- opus_test_file()
data <- read_opus(dsn = file)
cat("=== Read 1 OPUS file ===\n")
