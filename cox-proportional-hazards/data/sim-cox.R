# Simulate time-to-event data

library(tidyverse)
library(here)

# Directories used
cox_data_dir <- here("cox-proportional-hazards", "data")

# Functions ===================================================================

#' Simulate ideal data for the Cox model
#'
#' @param nsam Sample size
#' @param beta_0,beta_logtitre Regression coefficients for loghazard
#' @param max_follow Maximum follow-up time
#' @param seed Integer seed to use. Random integer by default
sim_cox <- function(nsam = 1e3,
                    beta_0 = -3, beta_logtitre = -1.5,
                    max_follow = 100,
                    seed = sample.int(.Machine$integer.max, 1)) {
  set.seed(seed)
  tibble(
    logtitre = rnorm(nsam, 2, 2),
    loghazard = beta_0 + beta_logtitre * logtitre,
    time_at_risk_required = rexp(nsam, rate = exp(loghazard)),
    status = as.integer(time_at_risk_required <= max_follow),
    time_recorded = if_else(
      status == 1L,
      time_at_risk_required,
      max_follow
    )
  )
}

# Script ======================================================================

# Simulate data
data_sim_cox <- sim_cox(
  nsam = 200,
  beta_0 = -3, beta_logtitre = -1.5,
  max_follow = 100,
  seed = 20200326
)

# Save simulated data
write_csv(data_sim_cox, file.path(cox_data_dir, "sim-cox.csv"))
