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

rix(
  r_ver = "latest-upstream",
  r_pkgs = c("altdoc", "devtools"),
  project_path = file.path("nix_envs", "r-pages"),
  overwrite = TRUE
)

rix(
  r_ver = "latest-upstream",
  r_pkgs = c("mirai", "devtools"),
  system_pkgs = "hyperfine",
  project_path = file.path("nix_envs", "r-benchmark"),
  overwrite = TRUE
)
