source('R/functions.R')
output <- yaml::yaml.load_file('_includes/awards.yaml')[[1]]
ordered_output <- order_by_year(output)

for (i in ordered_output) {
    if (restricted_entry(i)) next
    timeline <- convert_date(i$end)
    if (all(!is.null(i$start), i$start != i$end)) {
        timeline <- convert_date(i$start, i$end)
    }

    amount <- ''
    if (!is.null(i$value))
        amount <- paste0('Value: ', i$value, '. ')

    cat(timeline, '\n: *',
        i$title,'*, ',i$source,'\n\n\t',
        amount, i$other,'\n\n',
        sep = '')
}
