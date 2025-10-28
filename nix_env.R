library("rix")

rix(
  r_ver = "latest-upstream",
  r_pkgs = c("rcmdcheck"),
  ide = "none",
  project_path = ".",
  overwrite = TRUE
)
