# Plots the sclaed logit predictions for protection

library(tidyverse)
library(here)

# Directories used
fit_dir <- here("model-fit")
prot_plot_dir <- here("protect-plot")

# Functions ===================================================================

#' Generates the plot
#'
#' @param sclr_fit Predictions from the logistic model
gen_plot <- function(sclr_fit) {
  sclr_fit %>%
    ggplot(aes(logtitre, prot_point)) +
    theme_bw() +
    theme(
      panel.grid.minor.y = element_blank()
    ) +
    coord_cartesian(
      xlim = c(log(5), log(1280)),
      ylim = c(0, 1)
    ) +
    scale_x_continuous(
      "Titre",
      breaks = log(5 * 2^(0:8)),
      labels = 5 * 2^(0:8),
      minor_breaks = log(7.5 * 2^(0:8)),
    ) +
    scale_y_continuous(
      "Protection",
      labels = scales::percent_format()
    ) +
    geom_ribbon(
      aes(ymin = prot_l, ymax = prot_u),
      alpha = 0.5
    ) +
    geom_line()
}

#' Saves the plot
#'
#' @param plot Plot object
#' @param name Name to give to the file
save_plot <- function(plot, name) {
  ggsave(
    file.path(prot_plot_dir, glue::glue("{name}.pdf")),
    plot,
    width = 12, height = 7.5, units = "cm"
  )
}

# Script ======================================================================

# Fitted values. Run `fit-sclr.R` in the `model-fit` folder to
# generate `predict-sclr.csv`
sclr_fit <- read_csv(file.path(fit_dir, "predict-sclr.csv"), col_types = cols())

# Plot of protection
sclr_plot <- gen_plot(sclr_fit)

# Save plot to the same directory as the script
save_plot(sclr_plot, "protect-sclr")
