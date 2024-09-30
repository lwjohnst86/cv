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

# library(tidyverse)
# read_csv("data/cv-items.csv") |>
#   filter(section == "teaching") |>
#   select(-section, -doi, -value, -teaching_level) |>
#   rename(
#     href = website,
#     supervisor = person_name,
#     description = details,
#     `start-date` = start,
#     `end-date` = end
#   ) |>
#   mutate(across(where(is.character), \(x) if_else(is.na(x), "", x))) |>
#   mutate(
#     `start-date` = `start-date` |>
#       lubridate::as_date() |>
#       as.character(),
#     `end-date` = `end-date` |>
#       lubridate::as_date() |>
#       as.character(),
#     `end-date` = if_else(is.na(`end-date`), "", `end-date`),
#     organization = organization |>
#       stringr::str_replace_all("\\[(.*?)\\]\\(.*?\\)", "\\1")
#   ) |>
#   relocate(title, .before = everything()) |>
#   dataframe_to_list() |>
#   yaml::write_yaml("data/teaching.yml")

# Helpers -----------------------------------------------------------------

dataframe_to_list <- function(data) {
  data |>
    as.list() |>
    purrr::list_transpose(simplify = FALSE)
}
