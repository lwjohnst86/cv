#' @describeIn list_sections List all employment activities.
#' @export
list_employment <- function(.tbl, caption = NULL) {
  .tbl |>
    dplyr::filter(section == "employment") |>
    tidy_dates() |>
    vitae::detailed_entries(
      what = role,
      when = date_range,
      with = organization,
      where = location
    ) |>
    output(caption = caption)
}
