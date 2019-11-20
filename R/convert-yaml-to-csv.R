
# Used this to convert my old yaml data files into csv.
convert_yaml_to_csv <- function() {
    yaml_files <- fs::dir_ls(here("_includes/"), glob = "*.yaml")

    yaml_to_save <- yaml_files %>%
        str_remove(".*(publications|misc).*") %>%
        na_if("") %>%
        na.omit()

    basename(yaml_to_save)

    yaml_to_save %>%
        map(yaml::read_yaml) %>%
        flatten() %>%
        imap_dfr( ~ imap_dfr(.x, as_tibble) %>%
                      mutate(section = .y)) %>%
        write_csv(here("data/cv-items.csv"))

    cv_data <- read_csv("data/cv-items.csv")
    cv_data %>%
        mutate(
            role = if_else(!is.na(status), status, role),
            details = if_else(!is.na(other), other, details),
            organization = case_when(!is.na(org) ~ org,
                                     !is.na(source) ~ source,
                                     TRUE ~ NA_character_),
            person_name = case_when(
                !is.na(supervisor) ~ supervisor,
                !is.na(name) ~ name,
                TRUE ~ NA_character_
            )
        ) %>%
        select(start, end, title, everything()) %>%
        select(-status, -certificate, -org, -source,
               -supervisor, -name, -other) %>%
        write_csv(here("data/cv-data-2.csv"))
}
