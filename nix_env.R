library("rix")

cran_pkgs <- c("rcmdcheck", "knitr", "rmarkdown", "testthat", "progressr")

git_pkgs <- list(
  list(
    package_name = "mirai",
    repo_url = "https://github.com/r-lib/mirai/",
    commit = "6895fea0853515f01deb67d3fd3890fcaf1105b0"
  ),
  list(
    package_name = "nanonext",
    repo_url = "https://github.com/r-lib/nanonext",
    commit = "ad23cd52ffcf7f6d285a525181a06aedf361541e"
  )
)

rix(
  r_ver = "latest-upstream",
  r_pkgs = cran_pkgs,
  git_pkgs = git_pkgs,
  ide = "none",
  project_path = ".",
  overwrite = TRUE
)
