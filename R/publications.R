#' @describeIn list_sections List all publications.
#' @export
list_publications <- function(.tbl, type) {
    .tbl %>%
        dplyr::filter(stringr::str_detect(groups, type)) %>%
        dplyr::arrange(dplyr::desc(year)) %>%
        output(from_bib = TRUE)
}

