#' Read in the `.bib` file of publications and research output.
#'
#' @return A [tibble::tibble()] of the research outputs and publications.
#' @export
#'
read_bib_items <- function() {
  fs::path_package("cv", "data", "work.bib") |>
    bib2df::bib2df(separate_names = TRUE) |>
    dplyr::rename_with(snakecase::to_snake_case) |>
    dplyr::filter(category != "COMMENT")
}
