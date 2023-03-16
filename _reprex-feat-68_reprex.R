#' ---
#' output: reprex::reprex_document
#' ---

#' ---
#' output: reprex::reprex_document
#' ---

#' ---
#' output: reprex::reprex_document
#' ---

#' ---
#' output: reprex::reprex_document
#' ---

devtools::load_all()
file <- opus_file()
files <- rep(file, 10)

data_1 <- read_opus_single(dsn = file)
microbenchmark::microbenchmark(
  read_opus(dsn = files)
)
data_1 <- read_opus_single(dsn = file)
microbenchmark::microbenchmark(
  read_opus(dsn = file)
)

class(data_1)
class(data)
class(data[[1]])

remotes::install_github(
  "spectral-cockpit/opusreader2",
  ref = "feat-71-progress-bar", force = TRUE
)
library("opusreader2")

file <- opus_file()
files_1000 <- rep(file, 1000L)

# test progress updates --------------------------------------------------------

# register parallel backend (multisession; using sockets)
future::plan(future::multisession)
library("progressr")
handlers(global = TRUE)
handlers("progress") # base R progress animation

# the parallel option currently only monitors progress in the outer loop
# chunks of files, but works :-)
bench::mark(
  read_opus(dsn = files_1000, parallel = TRUE, progress_bar = TRUE)
)
