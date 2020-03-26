# Fit the Cox model to the simulated data

library(tidyverse)
library(survival)
library(here)

# Directories used
cox_data_dir <- here("cox-proportional-hazards", "data")
cox_fit_dir <- here("cox-proportional-hazards", "model-fit")

# Functions ===================================================================

#' Reads the simulated cox data
read_data_sim_cox <- function() {
  dat_file <- file.path(cox_data_dir, "sim-cox.csv")
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

#' Generates predictions for the Cox model
#'
#' This needs to be implemented manually because the default `predict()` will
#' center the predictions on the mean of all the covariates
#' See `?predict.coxph` for more information
#'
#' @param fit_cox Object returned by `coxph`
#' @param newdata Dataframe that holds the covariates used in the formula
#'   that generated `fit_cox`
predict_cox <- function(fit_cox, newdata) {
  beta_x <- coef(fit_cox)[[1]]
  var_beta_x <- vcov(fit_cox)[1, 1]
  newdata %>%
    mutate(
      fit = beta_x * logtitre_centered,
      fit_se = sqrt(logtitre_centered^2 * var_beta_x)
    )
}

#' Generates the protection estimates
#'
#' @param predictions Returned by `predict_cox`
gen_protection <- function(predictions) {
  predictions %>%
    mutate(
      fit_low = fit - qnorm(0.975) * fit_se,
      fit_high = fit + qnorm(0.975) * fit_se,
      protection = 1 - exp(fit),
      protection_low = 1 - exp(fit_high),
      protection_high = 1 - exp(fit_low)
    )
}

# Script ======================================================================

data_sim_cox <- read_data_sim_cox() %>%
  mutate(logtitre_centered = logtitre - log(5))

cox_fit <- coxph(
  Surv(time_recorded, event = status) ~ logtitre_centered,
  data_sim_cox
)

data_to_fit <- tibble(
  logtitre = seq(0, 8, length.out = 101),
  logtitre_centered = logtitre - log(5)
)

cox_predictions <- predict_cox(cox_fit, data_to_fit)

cox_prot <- gen_protection(cox_predictions)

write_csv(cox_prot, file.path(cox_fit_dir, "fit.csv"))
