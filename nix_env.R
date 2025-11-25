library("rix")

cran_pkgs <- c("rcmdcheck", "knitr", "rmarkdown", "testthat", "progressr")

rix(
  r_ver = "latest-upstream",
  r_pkgs = cran_pkgs,
  system_pkgs = c("html-tidy", "qpdf"),
  tex_pkgs = c("amsmath", "inconsolata"),
  ide = "none",
  project_path = ".",
  overwrite = TRUE
)
