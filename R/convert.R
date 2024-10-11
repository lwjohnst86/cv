# Education from ORCID ----------------------------------------------------

#' Get education information from ORCID and save as a YAML file.
#'
#' @param orcid Person's ORCID.
#' @param path The path to save the YAML file.
#'
#' @return Outputs the path to the saved YAML file.
#' @export
#'
#' @examples
#' orcid <- "0000-0003-4169-2616"
#' orcid_education_to_yml(orcid, here::here("data/education.yml"))
orcid_education_to_yaml <- function(orcid, path) {
  orcid |>
    orcid_get_education() |>
    dataframe_to_list() |>
    yaml::write_yaml(path)
  path
}

orcid_get_education <- function(orcid) {
  orcid_education_data <- rorcid::orcid_educations(orcid)[[1]]
  orcid_education_data$`affiliation-group`$summaries |>
    dplyr::bind_rows() |>
    dplyr::rename_all(~ stringr::str_remove(., "education-summary\\.")) |>
    dplyr::as_tibble(.name_repair = "universal") |>
    dplyr::mutate(
      title = glue::glue("{role.title} in {department.name}"),
      `start-date` = glue::glue("{start.date.year.value}-{start.date.month.value}-{start.date.day.value}"),
      `end-date` = glue::glue("{end.date.year.value}-{end.date.month.value}-{end.date.day.value}"),
      location = glue::glue("{organization.name} in {organization.address.city}, {organization.address.country}"),
      href = url.value,
      description = "",
      .keep = "none"
    )
}

# CRAN R packages ---------------------------------------------------------

#' Get CRAN R package details and save as a YAML file.
#'
#' @param author The package author's name to search for.
#' @param path The output file path
#'
#' @return The path to the saved YAML file.
#' @export
#'
#' @examples
#' cran_packages_to_yaml("Luke Johnston", here::here("data/r-packages.yml"))
cran_packages_to_yaml <- function(author, path) {
  author |>
    get_cran_packages() |>
    dataframe_to_list() |>
    yaml::write_yaml(path)
  path
}

get_cran_packages <- function(author) {
  my_pkgs <- pkgsearch::ps(author)
  my_pkgs |>
    dplyr::mutate(authorship = purrr::map_chr(
      package_data,
      ~ stringr::str_extract(.x$Author, glue::glue("{author}.*\\[(aut|ctb)(,|\\])"))
    )) |>
    dplyr::as_tibble() |>
    dplyr::arrange(dplyr::desc(date)) |>
    dplyr::mutate(
      authorship = dplyr::case_when(
        stringr::str_detect(authorship, "\\[ctb") ~ "contributor",
        stringr::str_detect(authorship, "\\[aut") ~ "creator"
      ) |>
        stringr::str_to_sentence(),
    ) |>
    dplyr::filter(!is.na(authorship)) |>
    dplyr::mutate(
      title = stringr::str_replace_all(title, "\n", " "),
      title = glue::glue("{package}: {title}"),
      description = stringr::str_replace_all(description, "\n", " "),
      description = glue::glue("{authorship}. {description}"),
      `start-date` = package |>
        extract_first_published() |>
        lubridate::as_datetime() |>
        lubridate::as_date() |>
        as.character(),
      href = url |>
        stringr::str_extract(".*(,[\n ])?") |>
        stringr::str_remove(",[\n ]"),
      location = "CRAN",
      .keep = "none"
    )
}

extract_first_published <- function(pkgs) {
  pkgs |>
    purrr::map(~ glue("https://crandb.r-pkg.org/{.x}/all")) |>
    purrr::map_chr(~ jsonlite::fromJSON(as.character(.x))$versions[[1]]$date)
}


# Bib to YAML -------------------------------------------------------------

#' Read in the `.bib` file of publications and research output.
#'
#' @return A [tibble::tibble()] of the research outputs and publications.
#'
read_bib_items <- function() {
  here::here("data", "work.bib") |>
    bib2df::bib2df(separate_names = TRUE) |>
    dplyr::rename_with(snakecase::to_snake_case) |>
    dplyr::filter(category != "COMMENT") |>
    dplyr::select(
      category, bibtexkey, author, booktitle, note,
      title, groups, url, doi, doi_code, doi_poster,
      comment, doi_preprint, isbn, ean, issn, year, address
    )
}

#' Convert curriculum development to YAML
#'
#' @param path File path to save to.
#'
#' @return A path of the created file.
#'
#' @examples
#' educational_resources_to_yaml(here::here("data/educational-resources.yml"))
educational_resources_to_yaml <- function(path) {
  list(list(
    section = "Educational resources",
    icon = "book-open-reader",
    description = "Educational resources that I've developed or contributed to.",
    entries = read_bib_items() |>
      dplyr::filter(stringr::str_detect(groups, "Curriculum development")) |>
      dplyr::mutate(year = as.character(year), roles = "") |>
      dplyr::select(title, href = url, doi, description = comment, location = note,
                    start = year, end = year) |>
      dataframe_to_list()
  )) |>
    yaml::write_yaml(path)
  path
}

#' Convert presentations to YAML
#'
#' @param path File path to save to.
#'
#' @return A path of the created file.
#'
#' @examples
#' presentations_to_yaml(here::here("data/presentations.yml"))
presentations_to_yaml <- function(path) {
  list(list(
    section = "Presentations",
    icon = "comment-dots",
    description = "Work that I have contributed to or that I've lead that was presented at conferences, seminars, and other events, either online or in-person.",
    entries = read_bib_items() |>
      dplyr::filter(stringr::str_detect(groups, "presentations")) |>
      dplyr::mutate(year = as.character(year), roles = "",
      type = stringr::str_remove(groups, " presentations")) |>
      dplyr::select(title, organization = booktitle, note, doi, type, location = address,
                    url, start = year, end = year) |>
      dataframe_to_list()
  )) |>
    yaml::write_yaml(path)
  path
}

#' Convert books to YAML
#'
#' @param path File path to save to.
#'
#' @return A path of the created file.
#'
#' @examples
#' books_to_yaml(here::here("data/books.yml"))
books_to_yaml <- function(path) {
  list(list(
    section = "Books",
    icon = "book",
    description = "Work that has been published as a book.",
    entries = read_bib_items() |>
      dplyr::filter(stringr::str_detect(groups, "Books")) |>
      dplyr::mutate(year = as.character(year), roles = "") |>
      dplyr::select(title, isbn, start = year, end = year) |>
      dataframe_to_list()
  )) |>
    yaml::write_yaml(path)
  path
}

#' Convert articles to YAML
#'
#' @param path File path to save to.
#'
#' @return A path of the created file.
#'
#' @examples
#' articles_to_yaml(here::here("data/articles.yml"))
articles_to_yaml <- function(path) {
  list(list(
    section = "Journal articles",
    icon = "book-open",
    description = "Academic outputs that lead to an article published in a journal.",
    entries = read_bib_items() |>
      dplyr::filter(groups == "Journal articles") |>
      dplyr::mutate(year = as.character(year), roles = "") |>
      dplyr::select(title, doi, start = year, end = year, roles) |>
      dataframe_to_list()
  )) |>
    yaml::write_yaml(path)
  path
}

# Helpers -----------------------------------------------------------------

dataframe_to_list <- function(data) {
  data |>
    as.list() |>
    purrr::list_transpose(simplify = FALSE)
}
