library(tidyverse)

yaml_files <- fs::dir_ls(here::here("_includes/"), glob = "*.yaml")

yaml_files %>%
    str_remove(".*(publications|misc).*") %>%
    na_if("") %>%
    na.omit() %>%
    map(yaml::read_yaml) %>%
    flatten() %>%
    imap_dfr(~ imap_dfr(.x, as_tibble) %>%
             mutate(section = .y)) %>%
    write_csv(here::here("data/cv-items.csv"))
