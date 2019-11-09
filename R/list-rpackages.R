extract_first_published <- function(pkgs) {
    pkgs %>%
        purrr::map( ~ glue::glue("https://crandb.r-pkg.org/{.x}/all")) %>%
        purrr::map_chr( ~ jsonlite::fromJSON(as.character(.x))$versions[[1]]$Date)
}

save_rpkgs <- function() {
    my_pkgs <- pkgsearch::ps("Luke Johnston")
    my_pkgs <- my_pkgs %>%
        mutate(authorship = purrr::map_chr(
            package_data,
            ~ stringr::str_extract(.x$Author, "Luke Johnston.*\\[(aut|ctb)(,|\\])")
        )) %>%
        as_tibble() %>%
        select(package, title, description, date, url, authorship) %>%
        arrange(desc(date)) %>%
        mutate(
            authorship = case_when(
                stringr::str_detect(authorship, "\\[ctb") ~ "contributor",
                stringr::str_detect(authorship, "\\[aut") ~ "creator",
                TRUE ~ NA_character_
            )
        ) %>%
        filter(!is.na(authorship)) %>%
        mutate(first_published = package %>%
                   extract_first_published() %>%
                   lubridate::year()) %>%
        vitae::brief_entries(
            what = glue::glue("{package}: {title} ({authorship})"),
            when = first_published,
            # TODO: Might need to fix this depending on number of url
            with = "CRAN"
        )
    saveRDS(my_pkgs, here("data/rpackages.Rds"))
    return(invisible())
}

list_rpackages <- function() {
    rpkgs <- readRDS(here("data/rpackages.Rds"))
    if (interactive()) {
        rpkgs <- rpkgs %>%
            as_tibble()
    }

    if (knitr::is_html_output()) {
        stop("Fix rpkgs gluing.")
        rpkgs <- rpkgs %>%
            as_tibble() %>%
            glue_data("
            ### {with}

            {what}

            {where}

            {when}

            ")
    }

    rpkgs
}
