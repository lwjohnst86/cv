#' @describeIn list_sections List all committees.
#' @export
list_committees <- function(data, caption = NULL) {
  data |>
    dplyr::filter(section == "committee") |>
    tidy_dates() |>
    vitae::detailed_entries(
      what = title,
      when = date_range,
      with = organization,
      where = location
    ) |>
    output(caption = caption)
}
