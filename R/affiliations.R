#' @describeIn list_sections List all affiliations.
#' @export
list_affiliations <- function(.tbl) {
  .tbl |>
    dplyr::filter(section == "affiliations") |>
    tidy_dates() |>
    vitae::detailed_entries(
      what = role,
      when = date_range,
      with = organization,
      where = location
    ) |>
    output()
}
