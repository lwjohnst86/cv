#' @describeIn list_sections List all education taken or obtained.
#' @export
list_education <- function() {
    data("education", package = "cv")
    output(education)
}

save_education <- function() {
    orcid <- "0000-0003-4169-2616"
    orcid_education_data <- rorcid::orcid_educations(orcid)[[1]]
    education <- orcid_education_data$`affiliation-group`$summaries %>%
        dplyr::bind_rows() %>%
        dplyr::rename_all(~ stringr::str_remove(., "education-summary\\.")) %>%
        dplyr::as_tibble(.name_repair = "universal") %>%
        dplyr::select(
            department.name,
            role.title,
            dplyr::matches("start.date"),
            dplyr::matches("end.date"),
            dplyr::matches("organization"),
            url.value
        ) %>%
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
