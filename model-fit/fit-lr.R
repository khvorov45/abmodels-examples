# Fit the logistic model to the simulated data

library(tidyverse)
library(here)

# Directories used
data_dir <- here("data")
fit_dir <- here("model-fit")

# Functions ===================================================================

#' Reads the simulated lr data
read_data_sim_lr <- function() {
  dat_file <- file.path(data_dir, "sim-lr.csv")
  if (!file.exists(dat_file)) {
    stop("Run sim-lr.r in data to generate logistic data")
  }
  read_csv(
    dat_file,
    col_types = cols(
      status = col_integer()
    )
  )
}

#' Generates predictions for the logistic model
#'
#' @param fit_lr Object returned by `glm`
#' @param newdata Dataframe that holds the covariates used in the formula
#'   that generated `fit_lr`
predict_lr <- function(fit_lr, newdata) {
  pred_vals <- predict(fit_lr, newdata, se = TRUE)
  newdata %>%
    mutate(
      fit = pred_vals$fit,
      fit_se = pred_vals$se.fit
    )
}

#' Generates the protection estimates
#'
#' @param predictions Returned by `predict_lr`
gen_protection <- function(predictions) {
  invlogit <- function(x) 1 - 1 / (1 + exp(x))
  predictions %>%
    mutate(
      fit_low = fit - qnorm(0.975) * fit_se,
      fit_high = fit + qnorm(0.975) * fit_se,
      protection = 1 - invlogit(fit),
      protection_low = 1 - invlogit(fit_high),
      protection_high = 1 - invlogit(fit_low)
    )
}

# Script ======================================================================

# Simualated data
data_sim_lr <- read_data_sim_lr()

# Model fit
lr_fit <- glm(
  status ~ logtitre,
  binomial(link = "logit"),
  data_sim_lr,
)

# Covariate values for which we want the fitted values
data_to_fit <- tibble(
  logtitre = seq(0, 8, length.out = 101)
)

# Generate predictions manually
lr_predictions <- predict_lr(lr_fit, data_to_fit)

# Generate protection from the fit
lr_prot <- gen_protection(lr_predictions)

# Save the fit to the same folder as the script
write_csv(lr_prot, file.path(fit_dir, "predict-lr.csv"))
