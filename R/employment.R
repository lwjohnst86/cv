list_employment <- function(.tbl) {
    .tbl %>%
        filter(section == "employment") %>%
        arrange(desc(start)) %>%
        mutate(
            start = lubridate::year(start),
            end = lubridate::year(end),
            end = if_else(is.na(end), "present", as.character(end))
        ) %>%
        vitae::detailed_entries(
            what = role,
            when = glue("{start} -- {end}"),
            with = organization,
            where = location
        ) %>%
        output()
}
# ### what (role)
# organization
# location
# date range
# optional descriptions
