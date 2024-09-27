#' @describeIn list_sections List all funding and grants given.
#' @export
list_funding <- function(data) {
  data |>
    dplyr::filter(section == "funding") |>
    dplyr::mutate(
      start = dplyr::if_else(is.na(start), end, start),
      year = lubridate::year(start),
      amount = dplyr::if_else(is.na(value), "",
        paste0("(", value, ")")
      )
    ) |>
    vitae::brief_entries(
      what = glue::glue("{title} from {organization} {amount}"),
      when = year,
      with = location
    ) |>
    output()
}
