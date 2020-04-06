# Simulate binary data

library(tidyverse)
library(extraDistr)
library(here)

# Directories used
lr_data_dir <- here("logistic-regression", "data")

# Functions ===================================================================

#' Simulate ideal data for the logistic model
#'
#' @param nsam Sample size
#' @param beta_0,beta_logtitre Regression coefficients for logit probability of
#'   infection
#' @param seed Integer seed to use. Random integer by default
sim_lr <- function(nsam = 1e3,
                   beta_0 = 3, beta_logtitre = -1.5,
                   seed = sample.int(.Machine$integer.max, 1)) {
  set.seed(seed)
  tibble(
    logtitre = rnorm(nsam, 2, 2),
    logitpr = beta_0 + beta_logtitre * logtitre,
    pr = 1 - 1 / (1 + exp(logitpr)),
    status = as.integer(rbern(nsam, pr))
  )
}

# Script ======================================================================

# Simulate data
data_sim_lr <- sim_lr(
  nsam = 200,
  beta_0 = 5, beta_logtitre = -1.5,
  seed = 20200326
)

# Save simulated data
write_csv(data_sim_lr, file.path(lr_data_dir, "sim-lr.csv"))
