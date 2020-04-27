# Bootstrap fit the logistic model to the simulated data

library(tidyverse)
library(furrr)

plan(multiprocess)

# Directories used
data_dir <- here::here("data")
fit_dir <- here::here("model-fit")

# Functions ===================================================================

source(file.path(data_dir, "read_data.R"))

#' Takes data resamples and fits the logistic model to each
#'
#' All errors and warnings are discarded
#'
#' @param dat Original data
#' @param n_res Number of resamples to take
boot_fit <- function(dat, n_res = 1000) {
  resamples <- rsample::bootstraps(dat, times = n_res)
  fit_one <- function(split, ind) {
    dat <- rsample::analysis(split)
    fit <- broom::tidy(
      glm(status ~ logtitre, dat, family = binomial(link = "logit"))
    )
    if (!is.null(fit)) fit$ind <- ind
    fit
  }
  future_imap_dfr(
    resamples$splits, fit_one,
    .options = future_options(packages = "broom")
  ) %>%
    mutate(term = recode(term, "(Intercept)" = "b0", "logtitre" = "bx"))
}

# Script ======================================================================

# Simulated data
data_sim_lr <- read_data("sim-lr")

# Bootstrap fit
lr_fit_boot <- boot_fit(data_sim_lr, 2000)

# Save bootstrap fit resutls
write_csv(lr_fit_boot, file.path(fit_dir, "boot-lr.csv"))
