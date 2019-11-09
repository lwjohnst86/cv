
# From old files to new csv format.
convert_yaml_to_csv <- function() {

yaml_files <- fs::dir_ls(here::here("_includes/"), glob = "*.yaml")

yaml_to_save <- yaml_files %>%
    str_remove(".*(publications|misc).*") %>%
    na_if("") %>%
    na.omit()

basename(yaml_to_save)

yaml_to_save %>%
    map(yaml::read_yaml) %>%
    flatten() %>%
    imap_dfr(~ imap_dfr(.x, as_tibble) %>%
             mutate(section = .y)) %>%
    write_csv(here::here("data/cv-items.csv"))

cv_data <- read_csv("data/cv-items.csv")
cv_data %>%
    mutate(role = if_else(!is.na(status), status, role),
           details = if_else(!is.na(other), other, details),
           organization = case_when(
               !is.na(org) ~ org,
               !is.na(source) ~ source,
               TRUE ~ NA_character_
           ),
           person_name = case_when(
               !is.na(supervisor) ~ supervisor,
               !is.na(name) ~ name,
               TRUE ~ NA_character_
           )) %>%
    select(start, end, title, everything()) %>%
    select(-status, -certificate, -org, -source,
           -supervisor, -name, -other) %>%
    write_csv("data/cv-data-2.csv")
}
