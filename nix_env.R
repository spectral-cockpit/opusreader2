library("rix")

cran_pkgs <- c("rcmdcheck", "knitr", "rmarkdown", "testthat", "progressr",
  "devtools")

rix(
  r_ver = "latest-upstream",
  r_pkgs = cran_pkgs,
  system_pkgs = "html-tidy",
  tex_pkgs = c("amsmath", "inconsolata"),
  ide = "none",
  project_path = ".",
  overwrite = TRUE
)
