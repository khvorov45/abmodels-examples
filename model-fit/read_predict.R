#' Reads predictions
#'
#' @param name Name of predictions. Will be prefixed by `predict-`
read_predict <- function(name) {
  read_csv(
    file.path(fit_dir, glue::glue("predict-{name}.csv")),
    col_types = cols()
  )
}
