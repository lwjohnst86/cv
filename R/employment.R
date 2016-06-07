source('R/functions.R')
output <- yaml.load_file('_includes/employment.yaml')$employment
ordered_output <- order_by_year(output)

for (i in ordered_output) {
    if (is.null(i$end)) {
        timeline <- paste0(convert_date(i$start), ' -- present')
    } else {
        timeline <- convert_date(i$start, i$end)
    }
    cat(timeline, '\n: *',
        i$role, '*, ', i$org, '\n\n\t',
        i$details, 'Supervisor: ', i$supervisor, '\n\n',
        sep = '')
}
