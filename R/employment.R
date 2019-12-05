list_employment <- function(.tbl) {
    .tbl %>%
        dplyr::filter(section == "employment") %>%
        tidy_dates() %>%
        vitae::detailed_entries(
            what = role,
            when = date_range,
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
