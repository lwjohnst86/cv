convert_to_cvhonors <- function(.tbl) {
    .tbl %>%
        tibble::as_tibble() %>%
        glue_data("

        \\cvhonors{{{what}}}{{{with}}}{{{where}}}{{{when}}}

                  ")
}

output <- function(.object, compact = FALSE, from_bib = FALSE, caption = NULL) {
    if (knitr::is_html_output()) {
        if (from_bib) {
            cat(.object, sep = "\n")
        } else {
            # .object <- .object %>%
            #     tibble::as_tibble() %>%
            #     dplyr::mutate_all(~ dplyr::if_else(is.na(.), "N/A", as.character(.)))
            #
            # if (!"where" %in% names(.object)) {
            #     .object <- .object %>%
            #         dplyr::mutate(where = "N/A")
            # }
            .object <- .object %>%
                ungroup()

            if (!"where" %in% names(.object)) {
                .object <- .object %>%
                    dplyr::mutate(where = "")
            } else {
                .object <- .object %>%
                    dplyr::mutate(where = if_else(is.na(where), "",
                                                  as.character(glue::glue("in {where}"))))
            }
            .output_html_item(.object, caption = caption)
        }

    } else if (knitr::is_latex_output()) {
        if (from_bib) {
            cat(.object, sep = "\n")
        } else {
            .object
        }
    } else if (interactive()) {
        .object
    }
}

.output_html_item <- function(.tbl, caption) {
    .tbl %>%
        dplyr::transmute(when = when,
                         what = glue::glue("{what}, {with} {where}")) %>%
        knitr::kable(col.names = NULL, align = "ll", caption = caption, label = NA) %>%
        kableExtra::kable_styling(c("condensed"),
                                  full_width = TRUE) %>%
        kableExtra::column_spec(1, width = "20%", bold = TRUE)
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

website_theme_color <- "#006064"
fa <- function(icon) {
    output <- ""
    if (knitr::is_html_output() | interactive()) {
        output <- fontawesome::fa(name = icon, fill = website_theme_color)
    }
    output
}

