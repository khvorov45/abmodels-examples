#' Reads the data
#'
#' Depends on global variable `data_dir`
#'
#' @param name Name of the dataset
read_data <- function(name) {
  dat_file <- file.path(data_dir, glue::glue("{name}.csv"))
  if (!file.exists(dat_file)) {
    stop("Run sim.R to generate data")
  }
  read_csv(
    dat_file,
    col_types = cols(
      status = col_integer()
    )
  )
}
