convert_to_cvhonors <- function(.tbl) {
    .tbl %>%
        tibble::as_tibble() %>%
        glue_data("

        \\cvhonors{{{what}}}{{{with}}}{{{where}}}{{{when}}}

                  ")
}

output <- function(.object, compact = FALSE, from_bib = FALSE) {
    if (knitr::is_html_output()) {
        .object <- .object %>%
            tibble::as_tibble() %>%
            dplyr::mutate_all( ~ dplyr::if_else(is.na(.), "N/A", as.character(.)))



        if (!"where" %in% names(.object)) {
            .object <- .object %>%
                dplyr::mutate(where = "N/A")
        }

        if (from_bib) {
            .output_html_resume_bib(.object)
        } else {
            .output_html_resume_item(.object)
        }

    } else if (knitr::is_latex_output()) {
        .object
    } else if (interactive()) {
        .object %>%
            .output_html_resume_bib()
            # tibble::as_tibble()
    }
}

.output_html_resume_bib <- function(.tbl) {
    .tbl %>%
        tibble::remove_rownames() %>%
        tibble::column_to_rownames("key") %>%
        RefManageR::as.BibEntry()
}

.output_html_resume_item <- function(.tbl) {
    .tbl %>%
        glue_data("

        ### {with}

        {what}

        {where}

        {when}

        ")
}

#' Tidy up date variables.
#'
#' @param .tbl Dataset to tidy with `start` and `end` date variables.
#'
#' @return A [tibble::tibble()] dataset with tidied date variables.
#' @export
#'
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

#' Timestamp for today.
#'
#' @return Outputs string with date as "March 1, 1999"
#' @export
#'
today_timestamp <- function() {
    lubridate::stamp('March 1, 1999', quiet = TRUE)(lubridate::today())
}
