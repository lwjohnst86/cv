output <- function(.object, compact = FALSE, from_bib = FALSE, caption = NULL) {
  if (knitr::is_html_output()) {
    if (from_bib) {
      cat(.object, sep = "\n")
    } else {
      .object <- .object |>
        ungroup()

      if (!"where" %in% names(.object)) {
        .object <- .object |>
          dplyr::mutate(where = "")
      } else {
        .object <- .object |>
          dplyr::mutate(where = if_else(is.na(where), "",
            as.character(glue::glue("in {where}"))
          ))
      }
      .output_html_item(.object, caption = caption)
    }
  } else if (interactive()) {
    .object
  }
}

.output_html_item <- function(data, caption) {
  data |>
    dplyr::transmute(
      when = when,
      what = glue::glue("{what}, {with} {where}")
    ) |>
    knitr::kable(col.names = NULL, align = "ll", caption = caption, label = NA)
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

save_education <- function() {
  orcid <- "0000-0003-4169-2616"
  orcid_education_data <- rorcid::orcid_educations(orcid)[[1]]
  education <- orcid_education_data$`affiliation-group`$summaries |>
    dplyr::bind_rows() |>
    dplyr::rename_all(~ stringr::str_remove(., "education-summary\\.")) |>
    dplyr::as_tibble(.name_repair = "universal") |>
    dplyr::select(
      department.name,
      role.title,
      dplyr::matches("start.date"),
      dplyr::matches("end.date"),
      dplyr::matches("organization"),
      url.value
    ) |>
    vitae::detailed_entries(
      what = glue("{role.title} in {department.name}"),
      when = glue("{start.date.year.value} -- {end.date.year.value}"),
      with = organization.name,
      where = stringr::str_c(
        organization.address.city,
        organization.address.country,
        sep = ", "
      ),
      why = url.value
    )

  usethis::use_data(education, overwrite = TRUE)
  return(invisible())
}

extract_first_published <- function(pkgs) {
  pkgs |>
    purrr::map(~ glue("https://crandb.r-pkg.org/{.x}/all")) |>
    purrr::map_chr(~ jsonlite::fromJSON(as.character(.x))$versions[[1]]$Date)
}

save_rpackages <- function() {
  my_pkgs <- pkgsearch::ps("Luke Johnston")
  rpackages <- my_pkgs |>
    dplyr::mutate(authorship = purrr::map_chr(
      package_data,
      ~ stringr::str_extract(.x$Author, "Luke Johnston.*\\[(aut|ctb)(,|\\])")
    )) |>
    dplyr::as_tibble() |>
    dplyr::select(package, title, description, date, url, authorship) |>
    dplyr::arrange(dplyr::desc(date)) |>
    dplyr::mutate(
      authorship = dplyr::case_when(
        stringr::str_detect(authorship, "\\[ctb") ~ "contributor",
        stringr::str_detect(authorship, "\\[aut") ~ "creator",
        TRUE ~ NA_character_
      )
    ) |>
    dplyr::filter(!is.na(authorship)) |>
    dplyr::mutate(first_published = package |>
      extract_first_published() |>
      lubridate::year()) |>
    vitae::brief_entries(
      what = glue("{package}: {title} ({authorship})"),
      when = first_published,
      # TODO: Might need to fix this depending on number of url
      with = "CRAN"
    )

  usethis::use_data(rpackages, overwrite = TRUE)
  return(invisible())
}
