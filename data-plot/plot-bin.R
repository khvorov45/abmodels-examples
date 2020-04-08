# Plot the simulated logistic and scaled logit data

library(tidyverse)
library(ggrepel)
library(here)

# Directories used
data_dir <- here("data")
data_plot_dir <- here("data-plot")

# Functions ===================================================================

#' Reads the simulated logistic regression data
read_data_sim_bin <- function(name) {
  dat_file <- file.path(data_dir, name)
  if (!file.exists(dat_file)) {
    stop("Run sim-lr.R and sim-sclr.R in data to generate binary data")
  }
  read_csv(
    dat_file,
    col_types = cols(
      status = col_integer()
    )
  )
}

#' Summarises the simulated binary data
#'
#' Calculates infected proportion for different titre groups
#'
#' @param data Simulated binary data (logistic or scaled logit)
summ_data_sim_bin <- function(data) {
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
plot_sim_bin <- function(summ) {
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

save_plot <- function(plot, name) {
  ggsave(
    file.path(data_plot_dir, name), plot,
    width = 12, height = 7.5, units = "cm"
  )
}

# Script ======================================================================

# Simualted data
datasets_sim_bin <- map(
  c("lr" = "sim-lr.csv", "sclr" = "sim-sclr.csv"),
  read_data_sim_bin
)

# Summarise the simulated data for plotting
summaries_sim_bin <- map(datasets_sim_bin, summ_data_sim_bin)

# Plot the summarised data
plots_sim_bin <- map(summaries_sim_bin, plot_sim_bin)
names(plots_sim_bin) <- glue::glue("plot-{names(plots_sim_bin)}.pdf")

# Save the plot to the same folder as the script
iwalk(plots_sim_bin, save_plot)
