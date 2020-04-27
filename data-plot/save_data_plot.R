#' Saves the plot
#'
#' @param plot A `ggplot` to save
#' @param name Name to save by. Will be prefixed with 'plot-'
save_data_plot <- function(plot, name) {
  ggsave(
    file.path(data_plot_dir, glue::glue("plot-{name}.pdf")), plot,
    width = 12, height = 7.5, units = "cm"
  )
}
