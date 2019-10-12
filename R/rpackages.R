source('R/functions.R')

library(tidyverse)
library(vitae)
extract_first_published <- function(pkgs) {
    pkgs %>%
        map(~ glue::glue("https://crandb.r-pkg.org/{.x}/all")) %>%
        map_chr(~ jsonlite::fromJSON(as.character(.x))$versions[[1]]$Date)
}

my_pkgs <- pkgsearch::ps("Luke Johnston")
my_pkgs %>%
    mutate(authorship = map_chr(
        package_data,
        ~ str_extract(.x$Author, "Luke Johnston.*\\[(aut|ctb)(,|\\])")
    )) %>%
    as_tibble() %>%
    select(package, title, description, date, url, authorship) %>%
    arrange(desc(date)) %>%
    mutate(
        authorship = case_when(
            str_detect(authorship, "\\[ctb") ~ "contributor",
            str_detect(authorship, "\\[aut") ~ "creator",
            TRUE ~ NA_character_
        )
    ) %>%
    filter(!is.na(authorship)) %>%
    mutate(first_published = package %>%
               extract_first_published() %>%
               lubridate::year()) %>%
    detailed_entries(what = glue::glue("{package}: {title} ({authorship})"),
                     when = glue::glue("{first_published} (updated: {lubridate::year(date)})"),
                     with = description,
                     # TODO: Might need to fix this depending on number of url
                     where = url) %>%
    as_tibble() %>%
    View()
