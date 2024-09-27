#' @describeIn list_sections List all awards given.
#' @export
list_awards <- function(.tbl, caption = NULL) {
  .tbl %>%
    dplyr::filter(section == "awards") %>%
    dplyr::mutate(
      start = dplyr::if_else(is.na(start), end, start),
      year = lubridate::year(start),
      amount = dplyr::if_else(is.na(value), "",
        paste0("(", value, ")")
      )
    ) %>%
    vitae::brief_entries(
      what = glue::glue("{title} from {organization} {amount}"),
      when = year,
      with = location
    ) %>%
    output(caption = caption)
}
