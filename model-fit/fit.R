# Fit the various models to the simulated data

library(tidyverse)

# Directories used
data_dir <- here::here("data")
fit_dir <- here::here("model-fit")

# Functions ===================================================================

source(file.path(data_dir, "read_data.R"))

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
      fit_se = sqrt(logtitre_centered^2 * var_beta_x),
      fit_low = fit - qnorm(0.975) * fit_se,
      fit_high = fit + qnorm(0.975) * fit_se,
      protection = 1 - exp(fit),
      protection_low = 1 - exp(fit_high),
      protection_high = 1 - exp(fit_low)
    )
}

#' Generates predictions for the logistic model
#'
#' @param fit_lr Object returned by `glm`
#' @param newdata Dataframe that holds the covariates used in the formula
#'   that generated `fit_lr`
predict_lr <- function(fit_lr, newdata) {
  invlogit <- function(x) 1 - 1 / (1 + exp(x))
  pred_vals <- predict(fit_lr, newdata, se = TRUE)
  newdata %>%
    mutate(
      fit = pred_vals$fit,
      fit_se = pred_vals$se.fit,
      fit_low = fit - qnorm(0.975) * fit_se,
      fit_high = fit + qnorm(0.975) * fit_se,
      protection = 1 - invlogit(fit),
      protection_low = 1 - invlogit(fit_high),
      protection_high = 1 - invlogit(fit_low)
    )
}

#' Saves predictions to the same folder as the file
#'
#' @param pred Predictions
#' @param name Name to save by. Will be prefixed with "predict-"
save_preds <- function(pred, name) {
  write_csv(pred, file.path(fit_dir, glue::glue("predict-{name}.csv")))
}

# Script ======================================================================

# Simulated data

data_sim_cox <- read_data("sim-cox") %>%
  mutate(logtitre_centered = logtitre - log(5))

data_sim_lr <- read_data("sim-lr")

data_sim_sclr <- read_data("sim-sclr")

# Model fit

cox_fit <- survival::coxph(
  survival::Surv(time_recorded, event = status) ~ logtitre_centered,
  data_sim_cox
)

lr_fit <- glm(status ~ logtitre, binomial(link = "logit"), data_sim_lr)

sclr_fit <- sclr::sclr(status ~ logtitre, data_sim_sclr)

# Covariate values for which we want the fitted values
data_to_fit <- tibble(
  logtitre = seq(0, 8, length.out = 101),
  logtitre_centered = logtitre - log(5)
)

# Generate predictions

all_preds <- list(
  cox = predict_cox(cox_fit, data_to_fit),
  lr = predict_lr(lr_fit, data_to_fit),
  sclr = predict(sclr_fit, data_to_fit)
)

# Save the predictions to the same folder as the script
iwalk(all_preds, save_preds)
