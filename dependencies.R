if (!"remotes" %in% rownames(installed.packages())) {
  install.packages("remotes")
}
remotes::update_packages(c(
  "tidyverse", "furrr", "here", "viridis", "extraDistr", "ggrepel", "rsample",
  "broom", "sclr"
))
