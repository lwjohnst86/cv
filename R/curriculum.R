source('R/functions.R')
output <- yaml::yaml.load_file('_includes/curriculum.yaml')$courses

ordered_output <- order_by_year(output)

for (i in ordered_output) {
    if (restricted_entry(i)) next
    if (is.null(i$end)) {
        timeline <- paste0(convert_date(i$start), ' -- present')
    } else {
        timeline <- convert_date(i$start, i$end)
    }
    website <- ''
    if (!is.null(i$website))
        website <- paste0('Website: ', i$website, '.')
    doi <- ""
    if (!is.null(i$doi))
        doi <- paste0("DOI: [", sub("^.*\\.org/", "", i$doi), "](", i$doi, ").")
    cat(timeline, '\n: *',
        i$title, '*, ', i$org, '\n\n\t',
        i$details, ' ', website, " ", doi, '\n\n',
        sep = '')
}
