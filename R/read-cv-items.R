#' Read in the CV dataset.
#'
#' @return A [tibble::tibble()] of all CV items.
#' @export
#'
read_cv_items <- function() {
    readr::read_csv(
        fs::path_package("cv", "data", "cv-items.csv"),
        col_types = readr::cols(
            start = readr::col_date(format = ""),
            end = readr::col_date(format = ""),
            title = readr::col_character(),
            details = readr::col_character(),
            website = readr::col_character(),
            section = readr::col_character(),
            value = readr::col_character(),
            doi = readr::col_character(),
            role = readr::col_character(),
            organization = readr::col_character(),
            person_name = readr::col_character(),
            location = readr::col_character(),
            teaching_level = readr::col_character(),
            teaching_number_students = readr::col_character()
        ))
}

#' Read in the `.bib` file of publications and research output.
#'
#' @return A [tibble::tibble()] of the research outputs and publications.
#' @export
#'
read_bib_items <- function() {
    fs::path_package("cv", "data", "work.bib") %>%
        bib2df::bib2df(separate_names = TRUE) %>%
        dplyr::rename_with(snakecase::to_snake_case) %>%
        dplyr::filter(category != "COMMENT")
}

read_bib <- function() {
    fs::path_package("cv", "data", "work.bib") %>%
        RefManageR::ReadBib() %>%
        print()
        # RefManageR::PrintBibliography()
}
