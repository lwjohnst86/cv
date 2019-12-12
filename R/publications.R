#' @describeIn list_sections List all publications.
#' @export
list_publications <- function(type) {
    bib_file <- fs::path_package("cv", "data", "work.bib")
    vitae::bibliography_entries(bib_file) %>%
        dplyr::filter(stringr::str_detect(groups, type)) %>%
        dplyr::arrange(dplyr::desc(year)) %>%
        output()
}

# doi <- paste0("DOI: [", sub("^.*\\.org/", "", i$doi), "](", i$doi, ").")
# ### title
# journal or poster location
# location or N/A
# year
# authors
