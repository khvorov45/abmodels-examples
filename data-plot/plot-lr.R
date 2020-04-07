# Plot the simulated logistic data

library(tidyverse)
library(ggrepel)
library(here)

# Directories used
data_dir <- here("data")
data_plot_dir <- here("data-plot")

# Functions ===================================================================

#' Reads the simulated logistic regression data
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

#' Summarises the simulated cox data
#'
#' Calculates ifected proportion for different titre groups
#'
#' @param data Simulated logistic data
summ_data_sim_lr <- function(data) {
  data %>%
    mutate(
      titre = exp(logtitre),
      titre_group = cut(
        titre, c(0, 10 * 2^(0:7), Inf),
        dig.lab = 4, right = FALSE
      )
    ) %>%
    group_by(titre_group) %>%
    summarise(
      n = n(),
      prop = sum(status) / n
    )
}

#' Plots simulated data
#'
#' @param summ Summarised simulated data
plot_sim_lr <- function(summ) {
  summ %>%
    ggplot(aes(titre_group, prop)) +
    theme_bw() +
    theme(
      axis.text.x = element_text(angle = 30, hjust = 1)
    ) +
    coord_cartesian(ylim = c(0, 1)) +
    scale_y_continuous(
      "Infected proportion",
      labels = scales::percent_format()
    ) +
    scale_x_discrete("Titre range") +
    geom_point() +
    geom_text_repel(aes(label = n)) +
    labs(caption = "Numbers are total group counts")
}

# Script ======================================================================

# Simualted data
data_sim_lr <- read_data_sim_lr()

# Summarise the simulated data for plotting
summ_sim_lr <- summ_data_sim_lr(data_sim_lr)

# Plot the summarised data
plot_sim_lr <- plot_sim_lr(summ_sim_lr)

# Save the plot to the same folder as the script
ggsave(
  file.path(data_plot_dir, "plot-lr.pdf"),
  width = 12, height = 7.5, units = "cm"
)
