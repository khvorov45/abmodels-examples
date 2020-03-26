# Plots the cox predictions for protection

library(tidyverse)
library(here)

# Directories used
cox_fit_dir <- here("cox-proportional-hazards", "model-fit")
cox_fit_plot_dir <- here("cox-proportional-hazards", "model-fit-plot")

# Functions ===================================================================

gen_plot <- function(cox_fit) {
  cox_fit %>%
    ggplot(aes(logtitre, protection)) +
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
      aes(ymin = protection_low, ymax = protection_high),
      alpha = 0.5
    ) +
    geom_line()
}

# Script ======================================================================

# Fitted values
cox_fit <- read_csv(file.path(cox_fit_dir, "fit.csv"), col_types = cols())

# Plot of protection
cox_plot <- gen_plot(cox_fit)

# Save plot to the same directory as the script
ggsave(
  file.path(cox_fit_plot_dir, "protection.pdf"),
  cox_plot,
  width = 12, height = 7.5, units = "cm"
)
