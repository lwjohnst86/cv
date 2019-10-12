
library(tidyverse)
library(glue)
rorcid::orcid_educations("0000-0003-4169-2616")[[1]]$`affiliation-group`$summaries %>%
    bind_rows() %>%
    rename_all( ~ str_remove(., "education-summary\\.")) %>%
    as_tibble(.name_repair = "universal") %>%
    select(department.name, role.title, matches("start.date"), matches("end.date"),
           matches("organization"), url.value) %>%
    vitae::detailed_entries(
        what = glue("{role.title} in {department.name}"),
        when = glue("{start.date.year.value} -- {end.date.year.value}"),
        with = organization.name,
        where = str_c(organization.address.city, organization.address.country, sep = ", "),
        why = url.value
    ) %>%
    as.tibble()


source('R/functions.R')
output <- yaml.load_file('_includes/education.yaml')
n <- names(output)
N <- gsub('^([a-z])', '\\U\\1', n, perl = TRUE)

ordered_certificates <- order_by_year(output$certificates)
ordered_courses <- order_by_year(output$courses)

cat('\n### ', N[2], '\n\n')
for (i in ordered_certificates) {
    if (is.null(i$start)) {
        timeline <- convert_date(i$end)
    } else {
        timeline <- convert_date(i$start, i$end)
    }
    website <- ''
    if (!is.null(i$website))
        website <- paste0('(',i$website,')')
    cat(timeline, '\n: *',
        i$title, '*\n\n\t',
        'Organization: ', i$org, '. ', website, '\n\n',
        sep = '')
}

cat('\n### ', N[3], '\n\n')
for (i in ordered_courses) {
    if (is.null(i$start)) {
        timeline <- convert_date(i$end)
    } else {
        timeline <- convert_date(i$start, i$end)
    }
    website <- ''
    if (!is.null(i$website))
        website <- paste0('(',i$website,')')

    if (is.null(i$end))
        timeline <- "Present"
    cat(timeline, '\n: *',
        i$title, '*\n\n\t',
        'Organization: ', i$org, '. ', website, '\n\n',
        sep = '')
}
