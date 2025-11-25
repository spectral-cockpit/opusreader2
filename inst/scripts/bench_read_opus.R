library("opusreader2")

file <- opus_test_file()
files_1000 <- rep(file, 1000L)

data <- read_opus(dsn = files_1000)

cat("=== Read 1000 OPUS file ===\n")
