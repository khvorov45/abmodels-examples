# Simulate time-to-event data

library(tidyverse)

# Directories used
data_dir <- here::here("data")

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
    status = as.integer(extraDistr::rbern(nsam, pr))
  )
}

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
    status = as.integer(extraDistr::rbern(nsam, pr))
  )
}

save_sim_data <- function(data, name) {
  write_csv(data, file.path(data_dir, glue::glue("sim-{name}.csv")))
}

# Script ======================================================================

# Simulate data

data_sim_cox <- sim_cox(
  nsam = 200,
  beta_0 = -3, beta_logtitre = -1.5,
  max_follow = 100,
  seed = 20200326
)

data_sim_lr <- sim_lr(
  nsam = 200,
  beta_0 = 5, beta_logtitre = -1.5,
  seed = 20200326
)

data_sim_sclr <- sim_sclr(
  nsam = 500,
  beta_0 = -5, beta_logtitre = 1.5, lambda = 0.5,
  seed = 20200326
)

# Save simulated data

all_sim_data <- list(
  cox = data_sim_cox,
  lr = data_sim_lr,
  sclr = data_sim_sclr
)

iwalk(all_sim_data, save_sim_data)
