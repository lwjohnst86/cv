source('R/functions.R')
output <- yaml::yaml.load_file('_includes/awards.yaml')[[1]]
ordered_output <- order_by_year(output)

for (i in ordered_output) {
    timeline <- paste0(substr(i$start, 0, 4))
    if (i$start != i$end)
        timeline <- paste0(substr(i$start, 0, 4),' - ', substr(i$end, 0, 4))

    amount <- ''
    if (!is.null(i$value))
        amount <- paste0('Value: ', i$value, '. ')

    cat(timeline, '\n: *',
        i$title,'*, ',i$source,'\n\n\t',
        amount, i$other,'\n\n',
        sep = '')
}
