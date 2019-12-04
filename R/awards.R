list_awards <- function(.tbl) {
    .tbl %>%
        dplyr::filter(section == "awards") %>%
        dplyr::mutate(start = dplyr::if_else(is.na(start), end, start),
               year = lubridate::year(start)) %>%
        vitae::brief_entries(
            what = glue("{title} from {organization}"),
            when = year,
            with = location
        ) %>%
        output()
}
