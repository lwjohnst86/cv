convert_to_cvhonors <- function(.tbl) {
    .tbl %>%
        tibble::as_tibble() %>%
        glue_data("

        \\cvhonors{{{what}}}{{{with}}}{{{where}}}{{{when}}}

                  ")
}

output <- function(.object, compact = FALSE) {
    if (interactive()) {
        .object %>%
            tibble::as_tibble()
    } else if (knitr::is_html_output()) {
        .object %>%
            tibble::as_tibble() %>%
            dplyr::mutate(where = dplyr::if_else(!"where" %in% names(.), "N/A", where)) %>%
            dplyr::mutate_all(~ dplyr::if_else(is.na(.), "N/A", .)) %>%
            glue_data("

            ### {with}

            {what}

            {where}

            {when}

            ")
    } else if (knitr::is_latex_output()) {
        .object
    }
}

tidy_dates <- function(.tbl) {
    .tbl %>%
        dplyr::arrange(dplyr::desc(start)) %>%
        dplyr::mutate(
            start = lubridate::year(start),
            end = lubridate::year(end),
            end = dplyr::if_else(is.na(end), "present", as.character(end)),
            date_range = dplyr::if_else(start == end, glue("{start}"), glue("{start} -- {end}"))
        )
}
