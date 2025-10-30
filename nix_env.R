library("rix")

cran_pkgs <- c("rcmdcheck", "knitr", "rmarkdown", "testthat", "progressr",
  "mirai")

rix(
  r_ver = "4.5.1",
  r_pkgs = cran_pkgs,
  system_pkgs = c("html-tidy", "qpdf"),
  tex_pkgs = c("amsmath", "inconsolata"),
  ide = "none",
  project_path = ".",
  overwrite = TRUE
)
