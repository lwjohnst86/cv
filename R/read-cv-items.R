read_cv_items <- function() {
    readr::read_csv(fs::path_package("cv", "data", "cv-items.csv"))
}
