source('R/functions.R')
output <- yaml.load_file('_includes/students.yaml')
ordered_output <- order_by_year(output)

for (i in ordered_output$phd) {
    if (is.null(i$end)) {
        timeline <- paste0(convert_date(i$start), ' -- present')
    } else {
        timeline <- convert_date(i$start, i$end)
    }
    cat(timeline, '\n: **',
        i$name, '**. Project: *', i$title, '*\n\n\t',
        i$details, '\n\n',
        sep = '')
}
