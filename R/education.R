source('R/functions.R')
output <- yaml::yaml.load_file('_includes/education.yaml')
n <- names(output)
N <- gsub('^([a-z])', '\\U\\1', n, perl = TRUE)

ordered_output <- order_by_year(output)

cat('\n### ', N[1], '\n\n')
for (i in ordered_output[[n[1]]]) {
    thesis <- ''
    if (!is.null(i$thesis))
        thesis <- paste0('[', i$thesis,
                         '](', i$link, ') Supervisor: ', i$supervisor)
    cat(i$end, '\n: *',
        i$degree, '*, ', i$university, '\n\n\t',
        thesis, '\n\n', sep = '')
}

cat('\n### ', N[2], '\n\n')
for (i in ordered_output[[n[2]]]) {
    website <- ''
    if (!is.null(i$website))
        website <- paste0('(',i$website,')')
    cat(i$end, '\n: *',
        i$title, '*\n\n\t',
        'Organization: ', i$org, '. ', website, '\n\n',
        sep = '')
}
