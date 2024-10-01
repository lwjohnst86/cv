#' @describeIn list_sections List all affiliations.
#' @export
list_affiliations <- function(data) {
  data |>
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

#' @describeIn list_sections List all publications.
#' @export
list_publications <- function(data, .type) {
  pub_format <- tibble::tribble(
    ~category, ~glue_exp,
    "article", "1. {presentation_type} '{title}'. {author}. ({year}). {doi}",
    "inproceedings", "1. {presentation_type} '{title}'. {author}. *{booktitle}* in {address} ({year}). {doi}",
    "book", "1. {presentation_type} '{title}'. {author}. ({year}). {url} {isbn}",
    "misc", "1. '{title}'. {author}. ({year}). {url} {doi}"
  )

  format_prep <- data |>
    dplyr::arrange(dplyr::desc(year)) |>
    dplyr::mutate(
      title = stringr::str_remove_all(title, "\\{|\\}"),
      presentation_type = stringr::str_remove(groups, " presentations"),
      presentation_type = if_else(stringr::str_detect(groups, "presentations"),
        as.character(glue::glue("({presentation_type})")),
        ""
      ),
      category = tolower(category),
      doi = dplyr::if_else(
        is.na(doi),
        "",
        paste0("DOI: [", doi, "](https://doi.org/", doi, ").")
      ),
      url = dplyr::if_else(
        is.na(url),
        "",
        paste0("URL: <", url, ">.")
      ),
      isbn = dplyr::if_else(
        is.na(isbn),
        "",
        paste0("ISBN: [", isbn, "](https://isbnsearch.org/isbn/", isbn, ").")
      ),
      author = purrr::map_chr(author, ~ stringr::str_c(.x$full_name, collapse = ", ")) |>
        stringr::str_replace("(L(uke|\\.)?( ?W\\.?)? Johnston)", "**\\1**"),
    ) |>
    dplyr::filter(category %in% c("article", "inproceedings", "misc", "book")) |>
    dplyr::filter(stringr::str_detect(groups, .type)) |>
    tidyr::nest(data = !category) |>
    dplyr::left_join(pub_format, by = "category")

  purrr::map2(
    format_prep$data,
    format_prep$glue_exp,
    ~ glue::glue_data(.x = .x, .y, sep = "\n")
  ) |>
    unlist() |>
    output(from_bib = TRUE)
}

#' @describeIn list_sections List curriculum developed.
#' @export
list_curriculum_development <- function(data, caption = NULL) {
  data |>
    dplyr::filter(section == "curriculum") |>
    tidy_dates() |>
    vitae::detailed_entries(
      what = glue("{title} ({website})"),
      when = date_range,
      with = organization,
      where = location,
      why = website
    ) |>
    output(caption = caption)
}

#' @describeIn list_sections List supervisory activities.
#' @export
list_supervision <- function(data, caption = NULL) {
  data |>
    dplyr::filter(section == "supervision") |>
    tidy_dates() |>
    vitae::detailed_entries(
      what = glue("{teaching_level} student"),
      when = date_range,
      with = organization,
      where = location
    ) |>
    output(caption = caption)
}
