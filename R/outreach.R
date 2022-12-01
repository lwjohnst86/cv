#' @describeIn list_sections List all outreach activities.
#' @export
list_outreach <- function(.tbl, caption = NULL) {
    .tbl %>%
        dplyr::filter(section == "outreach") %>%
        tidy_dates() %>%
        vitae::detailed_entries(
            what = glue::glue("{str_to_sentence(role)} for [{title}]({website}): {details}"),
            when = date_range,
            with = organization,
            where = location
        ) %>%
        output(caption = caption)
}
