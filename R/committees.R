#' @describeIn list_sections List all committees.
#' @export
list_committees <- function(.tbl, caption = NULL) {
    .tbl %>%
        dplyr::filter(section == "committee") %>%
        tidy_dates() %>%
        vitae::detailed_entries(
            what = role,
            when = date_range,
            with = organization,
            where = location
        ) %>%
        output(caption = caption)
}
