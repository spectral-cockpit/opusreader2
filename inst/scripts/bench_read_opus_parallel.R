library("opusreader2")
library("mirai")

daemons(n = 8L)

file <- opus_test_file()
files_1000 <- rep(file, 1000L)

data <- read_opus(dsn = files_1000, parallel = TRUE)

print(data)

cat("=== Read 1000 OPUS files ===\n")
