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

read_bib_items <- function() {
    vitae::bibliography_entries(fs::path_package("cv", "data", "work.bib"))
}
