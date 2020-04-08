# Fit the scaled logit model to the simulated data

library(tidyverse)
library(here)
library(sclr)

# Directories used
data_dir <- here("data")
fit_dir <- here("model-fit")

# Functions ===================================================================

#' Reads the simulated sclr data
read_data_sim_sclr <- function() {
  dat_file <- file.path(data_dir, "sim-sclr.csv")
  if (!file.exists(dat_file)) {
    stop("Run sim-sclr.r in data to generate scaled logit data")
  }
  read_csv(
    dat_file,
    col_types = cols(
      status = col_integer()
    )
  )
}

# Script ======================================================================

# Simulated data
data_sim_sclr <- read_data_sim_sclr()

# Model fit
sclr_fit <- sclr(
  status ~ logtitre,
  data_sim_sclr,
)

# Covariate values for which we want the fitted values
data_to_fit <- tibble(
  logtitre = seq(0, 8, length.out = 101)
)

# Generate predictions
sclr_predictions <- predict(sclr_fit, data_to_fit)

# Save the fit to the same folder as the script
write_csv(sclr_predictions, file.path(fit_dir, "predict-sclr.csv"))
