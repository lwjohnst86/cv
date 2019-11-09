
save_education <- function() {
    orcid <- "0000-0003-4169-2616"
    orcid_education_data <- rorcid::orcid_educations(orcid)[[1]]
    education <- orcid_education_data$`affiliation-group`$summaries %>%
        bind_rows() %>%
        rename_all(~ stringr::str_remove(., "education-summary\\.")) %>%
        as_tibble(.name_repair = "universal") %>%
        select(
            department.name,
            role.title,
            matches("start.date"),
            matches("end.date"),
            matches("organization"),
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
    saveRDS(education, here("data/education.Rds"))
    return(invisible())
}

list_education <- function() {

    education <- readRDS(here("data/education.Rds"))
    if (interactive()) {
        education <- education %>%
            as_tibble()
    }

    if (knitr::is_html_output()) {
        education <- education %>%
            as_tibble() %>%
            glue_data("
            ### {with}

            {what}

            {where}

            {when}

            ")
    }

    education
}
