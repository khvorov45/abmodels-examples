# Simulate binary data from the scaled logit model

library(tidyverse)
library(extraDistr)
library(here)

# Directories used
data_dir <- here("data")

# Functions ===================================================================

#' Simulate ideal data for the scaled logit model
#'
#' @param nsam Sample size
#' @param beta_0,beta_logtitre,lambda Regression coefficients
#' for the scaled logit probability of infection
#' @param seed Integer seed to use. Random integer by default
sim_sclr <- function(nsam = 1e3,
                     beta_0 = 3, beta_logtitre = -1.5, lambda = 0.5,
                     seed = sample.int(.Machine$integer.max, 1)) {
  set.seed(seed)
  tibble(
    logtitre = rnorm(nsam, 2, 2),
    logit_prot = beta_0 + beta_logtitre * logtitre,
    prot = 1 - 1 / (1 + exp(logit_prot)),
    pr = lambda * (1 - prot),
    status = as.integer(rbern(nsam, pr))
  )
}

# Script ======================================================================

# Simulate data
data_sim_sclr <- sim_sclr(
  nsam = 500,
  beta_0 = -5, beta_logtitre = 1.5, lambda = 0.5,
  seed = 20200326
)

# Save simulated data
write_csv(data_sim_sclr, file.path(data_dir, "sim-sclr.csv"))
