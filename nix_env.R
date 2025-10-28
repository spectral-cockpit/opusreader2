library("rix")

r_pkgs <- c("rcmdcheck", "knitr", "rmarkdown", "testthat", "progressr", "mirai")

rix(
  r_ver = "latest-upstream",
  r_pkgs = r_pkgs,
  ide = "none",
  project_path = ".",
  overwrite = TRUE
)
