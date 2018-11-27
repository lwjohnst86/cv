source('R/functions.R')
output <- yaml.load_file('_includes/education.yaml')
n <- names(output)
N <- gsub('^([a-z])', '\\U\\1', n, perl = TRUE)

ordered_degrees <- order_by_year(output$degrees)
ordered_certificates <- order_by_year(output$certificates)
ordered_courses <- order_by_year(output$courses)

cat('\n### ', N[1], '\n\n')
for (i in ordered_degrees) {
    if (is.null(i$end)) {
        timeline <- paste0(convert_date(i$start), ' -- present')
    } else if (is.null(i$start)) {
        timeline <- convert_date(i$end)
    } else {
        timeline <- convert_date(i$start, i$end)
    }

    co <- ""
    if (!is.null(i$co_supervisor))
        co <- glue("Co-supervisor: {i$co_supervisor}")

    supervisor <- ""
    if (!is.null(i$supervisor))
        supervisor <- glue("Supervisor: {i$supervisor}")

    thesis <- ''
    if (!is.null(i$thesis) & !is.null(i$link)) {
        thesis <- glue('[{i$thesis}]({i$link}) {supervisor}. {co}')
    } else if (!is.null(i$thesis) & is.null(i$link)) {
        thesis <- glue('{i$thesis} {supervisor}. {co}')
    }

    cat(timeline, '\n: *',
        i$degree, '*, ', i$university, '\n\n\t',
        thesis, '\n\n', sep = '')
}

cat('\n### ', N[2], '\n\n')
for (i in ordered_certificates) {
    if (is.null(i$start)) {
        timeline <- convert_date(i$end)
    } else {
        timeline <- convert_date(i$start, i$end)
    }
    website <- ''
    if (!is.null(i$website))
        website <- paste0('(',i$website,')')
    cat(timeline, '\n: *',
        i$title, '*\n\n\t',
        'Organization: ', i$org, '. ', website, '\n\n',
        sep = '')
}

cat('\n### ', N[3], '\n\n')
for (i in ordered_courses) {
    if (is.null(i$start)) {
        timeline <- convert_date(i$end)
    } else {
        timeline <- convert_date(i$start, i$end)
    }
    website <- ''
    if (!is.null(i$website))
        website <- paste0('(',i$website,')')

    if (is.null(i$end))
        timeline <- "Present"
    cat(timeline, '\n: *',
        i$title, '*\n\n\t',
        'Organization: ', i$org, '. ', website, '\n\n',
        sep = '')
}
