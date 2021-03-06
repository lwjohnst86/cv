#' @describeIn list_sections List all publications.
#' @export
list_publications <- function(.tbl, .type) {
    pub_format <- tibble::tribble(
        ~category, ~glue_exp,
        "article", "1. {presentation_type} {author}. '{title}'. *{journal}* ({year}). {doi}",
        "inproceedings", "1. {presentation_type} {author}. '{title}'. *{booktitle}* in {address} ({year}). {doi}",
        "misc", "1. {author}. '{title}'. ({year}). {url} {doi}"
    )

    format_prep <- .tbl %>%
        dplyr::arrange(dplyr::desc(year)) %>%
        dplyr::mutate(
            presentation_type = stringr::str_remove(groups, " presentations"),
            presentation_type = if_else(stringr::str_detect(groups, "presentations"),
                                        as.character(glue::glue("({presentation_type})")),
                                        ""),
            category = tolower(category),
            doi = dplyr::if_else(
                is.na(doi),
                "",
                paste0("DOI: [", doi, "](https://doi.org/", doi, ").")
            ),
            url = dplyr::if_else(
                is.na(url),
                "",
                paste0("URL: <", url, ">.")
            ),
            author = purrr::map_chr(author, ~ stringr::str_c(.x$full_name, collapse = ", ")) %>%
                stringr::str_replace("(L(uke|\\.)?( ?W\\.?)? Johnston)", "**\\1**"),
        ) %>%
        dplyr::filter(category %in% c("article", "inproceedings", "misc")) %>%
        dplyr::filter(stringr::str_detect(groups, .type)) %>%
        tidyr::nest(data = !category) %>%
        dplyr::left_join(pub_format, by = "category")

    purrr::map2(format_prep$data,
                format_prep$glue_exp,
                ~ glue::glue_data(.x = .x, .y, sep = "\n")) %>%
        unlist() %>%
        output(from_bib = TRUE)
}

