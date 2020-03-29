# Plot the simulated data

library(tidyverse)
library(viridis)
library(here)

# Directories used
cox_data_dir <- here("cox-proportional-hazards", "data")
cox_plot_dir <- here("cox-proportional-hazards", "data-plot")

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

#' Calculates surviving proportion for one timepoint
#'
#' @param time Timepoint to get the surviving proportion for
#' @param data Simulated Cox data
calc_surv_prop <- function(time, data) {
  data %>%
    summarise(
      time = time,
      infected = sum(status & time_recorded <= time),
      surv_prop = 1 - infected / n()
    )
}

#' Summarises the simulated cox data
#'
#' Calculates surviving proportion for different titre groups for timepoints
#' between 0 and 100
#'
#' @param data Simulated Cox data
summ_data_sim_cox <- function(data) {
  data %>%
    mutate(
      titre = exp(logtitre),
      titre_group = cut(
        titre, c(0, 10 * 2^(0:7), Inf),
        dig.lab = 4, right = FALSE
      )
    ) %>%
    group_by(titre_group) %>%
    group_modify(function(data, key) {
      map_dfr(0:100, ~ calc_surv_prop(.x, data))
    })
}

#' Plots survival curves
#'
#' @param summ Summarised simulated data
plot_sim_cox <- function(summ) {
  summ %>%
    ggplot(aes(time, surv_prop, col = titre_group)) +
    theme_bw() +
    theme() +
    coord_cartesian(ylim = c(0, 1)) +
    scale_y_continuous(
      "Non-infected proportion",
      labels = scales::percent_format()
    ) +
    scale_x_continuous("Time, days") +
    scale_color_viridis("Titre", discrete = TRUE) +
    geom_line()
}

# Script ======================================================================

# Simualted data
data_sim_cox <- read_data_sim_cox()

# Summarise the simulated data for plotting
summ_sim_cox <- summ_data_sim_cox(data_sim_cox)

# Plot the summarised data
plot_sim_cox <- plot_sim_cox(summ_sim_cox)

# Save the plot to the same folder as the script
ggsave(
  file.path(cox_plot_dir, "sim-plot.pdf"),
  width = 12, height = 7.5, units = "cm"
)
