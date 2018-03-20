source('R/functions.R')
output <- yaml.load_file('_includes/education.yaml')
n <- names(output)
N <- gsub('^([a-z])', '\\U\\1', n, perl = TRUE)

ordered_degrees <- order_by_year(output$degrees)
ordered_certificates <- order_by_year(output$certificates)
ordered_courses <- order_by_year(output$courses)

cat('\n### ', N[1], '\n\n')
for (i in ordered_degrees) {
    co <- ''
    if (!is.null(i$co_supervisor))
        co <- paste0('. Co-supervisor: ', i$co_supervisor)

    thesis <- ''
    if (!is.null(i$thesis) & !is.null(i$link)) {
        thesis <- paste0('[', i$thesis,
                         '](', i$link, ') Supervisor: ', i$supervisor, co)
    } else if (!is.null(i$thesis) & is.null(i$link)) {
        thesis <- paste0(i$thesis,' Supervisor: ', i$supervisor, co)
    }

    if (is.null(i$end))
        i$end <- "Present"
    cat(i$end, '\n: *',
        i$degree, '*, ', i$university, '\n\n\t',
        thesis, '\n\n', sep = '')
}

cat('\n### ', N[2], '\n\n')
for (i in ordered_certificates) {
    website <- ''
    if (!is.null(i$website))
        website <- paste0('(',i$website,')')
    cat(i$end, '\n: *',
        i$title, '*\n\n\t',
        'Organization: ', i$org, '. ', website, '\n\n',
        sep = '')
}

cat('\n### ', N[3], '\n\n')
for (i in ordered_courses) {
    website <- ''
    if (!is.null(i$website))
        website <- paste0('(',i$website,')')

    if (is.null(i$end))
        i$end <- "Present"
    cat(i$end, '\n: *',
        i$title, '*\n\n\t',
        'Organization: ', i$org, '. ', website, '\n\n',
        sep = '')
}
