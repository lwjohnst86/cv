#' @describeIn list_sections List all R packages developed (from CRAN).
#' @export
list_rpackages <- function(data) {
  output(data)
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
