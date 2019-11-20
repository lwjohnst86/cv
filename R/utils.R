convert_to_cvhonors <- function(.tbl) {
    .tbl %>%
        as_tibble() %>%
        glue_data("

        \\cvhonors{{{what}}}{{{with}}}{{{where}}}{{{when}}}

                  ")
}


output <- function(.object) {
    if (interactive()) {
        .object %>%
            as_tibble()
    } else if (knitr::is_html_output()) {
        .object %>%
            as_tibble() %>%
            mutate_all(~ if_else(is.na(.), "N/A", .)) %>%
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

