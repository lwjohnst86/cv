convert_to_cvhonors <- function(.tbl) {
    .tbl %>%
        tibble::as_tibble() %>%
        glue_data("

        \\cvhonors{{{what}}}{{{with}}}{{{where}}}{{{when}}}

                  ")
}

output <- function(.object, compact = FALSE, from_bib = FALSE) {
    if (knitr::is_html_output()) {
        cat("HTML\n\n")
        .object <- .object %>%
            tibble::as_tibble() %>%
            dplyr::mutate_all( ~ dplyr::if_else(is.na(.), "N/A", as.character(.)))



        if (!"where" %in% names(.object)) {
            .object <- .object %>%
                dplyr::mutate(where = "N/A")
        }

        if (from_bib) {
            .object
        } else {
            .object %>%
                glue_data("

                ### {with}

                {what}

                {where}

                {when}

                ")
        }

    } else if (knitr::is_latex_output()) {
        cat("PDF\n\n")
        .object
    } else if (interactive()) {
        cat("INTERACTIVE\n\n")
        .object %>%
            tibble::as_tibble()
    }
}

tidy_dates <- function(.tbl) {
    .tbl %>%
        dplyr::arrange(dplyr::desc(is.na(end)), dplyr::desc(start)) %>%
        dplyr::mutate(
            start = lubridate::year(start),
            end = lubridate::year(end),
            end = dplyr::if_else(is.na(end), "present", as.character(end)),
            date_range = dplyr::if_else(start == end, glue("{start}"), glue("{start} -- {end}"))
        )
}
