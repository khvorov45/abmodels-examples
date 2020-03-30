# Bootstrap fit the logistic model to the simulated data

library(tidyverse)
library(here)
library(rsample)
library(furrr)
library(broom)

plan(multiprocess)

# Directories used
lr_data_dir <- here("logistic-regression", "data")
lr_fit_boot_dir <- here("logistic-regression", "model-fit-boot")

# Functions ===================================================================

#' Reads the simulated lr data
read_data_sim_lr <- function() {
  dat_file <- file.path(lr_data_dir, "sim-lr.csv")
  if (!file.exists(dat_file)) {
    stop("Run sim.r in data to generate data")
  }
  read_csv(
    dat_file,
    col_types = cols(
      status = col_integer()
    )
  )
}

#' Takes data resamples and fits the logistic model to each
#'
#' All errors and warnings are discarded
#'
#' @param dat Original data
#' @param n_res Number of resamples to take
boot_fit <- function(dat, n_res = 1000) {
  resamples <- bootstraps(dat, times = n_res)
  fit_one <- function(split, ind) {
    dat <- analysis(split)
    fit <- tidy(glm(status ~ logtitre, dat, family = binomial(link = "logit")))
    if (!is.null(fit)) fit$ind <- ind
    fit
  }
  future_imap_dfr(
    resamples$splits, fit_one,
    .options = future_options(packages = "broom")
  ) %>%
    mutate(term = recode(term, "(Intercept)" = "b0", "loghimid" = "bx"))
}

# Script ======================================================================

# Simulated data
data_sim_lr <- read_data_sim_lr()

# Bootstrap fit
lr_fit_boot <- boot_fit(data_sim_lr, 2000)

# Save bootstrap fit resutls
write_csv(lr_fit_boot, file.path(lr_fit_boot_dir, "fit-boot.csv"))
