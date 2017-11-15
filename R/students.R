source('R/functions.R')
output <- yaml.load_file('_includes/students.yaml')
n <- names(output)
N <- gsub('^([a-z])', '\\U\\1', n, perl = TRUE)

ordered_undergrad <- order_by_year(output$undergraduate)
ordered_masters <- order_by_year(output$masters)

cat('\n### ', N[1], 'students\n\n')

for (i in ordered_undergrad) {
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

cat('\n### ', gsub("s$", "'s", N[2]), ' students\n\n')

for (i in ordered_masters) {
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
