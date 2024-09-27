#' @describeIn list_sections List all teaching activities.
#' @export
list_teaching <- function(.tbl, caption = NULL) {
  .tbl %>%
    dplyr::filter(section == "teaching") %>%
    tidy_dates() %>%
    dplyr::mutate(
      organization = organization %>%
        stringr::str_replace_all("\\[(.+?)\\]\\(.+?\\)", "\\1")
    ) %>%
    vitae::detailed_entries(
      what = glue("{str_to_sentence(role)} for {title} ({teaching_level})"),
      when = date_range,
      with = organization,
      where = location
    ) %>%
    output(caption = caption)
}

#' @describeIn list_sections List curriculum developed.
#' @export
list_curriculum_development <- function(.tbl, caption = NULL) {
  .tbl %>%
    dplyr::filter(section == "curriculum") %>%
    tidy_dates() %>%
    vitae::detailed_entries(
      what = glue("{title} ({website})"),
      when = date_range,
      with = organization,
      where = location,
      why = website
    ) %>%
    output(caption = caption)
}

#' @describeIn list_sections List supervisory activities.
#' @export
list_supervision <- function(.tbl, caption = NULL) {
  .tbl %>%
    dplyr::filter(section == "supervision") %>%
    tidy_dates() %>%
    vitae::detailed_entries(
      what = glue("{teaching_level} student"),
      when = date_range,
      with = organization,
      where = location
    ) %>%
    output(caption = caption)
}
