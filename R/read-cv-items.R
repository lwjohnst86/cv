#' Read in the `.bib` file of publications and research output.
#'
#' @return A [tibble::tibble()] of the research outputs and publications.
#' @export
#'
read_bib_items <- function() {
  here::here("data", "work.bib") |>
    bib2df::bib2df(separate_names = TRUE) |>
    dplyr::rename_with(snakecase::to_snake_case) |>
    dplyr::filter(category != "COMMENT")
}

output <- function(.object) {
  cat(.object, sep = "\n")
}

#' Tidy up date variables.
#'
#' @param data Dataset to tidy with `start` and `end` date variables.
#'
#' @return A [tibble::tibble()] dataset with tidied date variables.
#' @export
#'
tidy_dates <- function(data) {
  data |>
    dplyr::arrange(dplyr::desc(is.na(end)), dplyr::desc(start)) |>
    dplyr::mutate(
      start = lubridate::year(start),
      end = lubridate::year(end),
      end = dplyr::if_else(is.na(end), "present", as.character(end)),
      date_range = dplyr::if_else(start == end, glue("{start}"), glue("{start} -- {end}"))
    )
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
    output()
}
