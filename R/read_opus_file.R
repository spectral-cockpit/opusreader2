read_opus_file <- function(file) {
  # Get raw vector
  raw <- readBin(file, "raw", n = file.size(file))
}