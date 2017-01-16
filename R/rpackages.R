source('R/functions.R')
output <- yaml::yaml.load_file('_includes/rpackages.yaml')

cat('\n\n### CRAN\n\n')
for (i in output$rpackages$cran) {
    cat(i$pkg, '\n: ', paste0('_', i$title, '_: '), i$details, ' *First published*: ',
        convert_date(i$first_published), '\n\n')
}

cat('\n\n### GitHub\n\n')
for (i in output$rpackages$github) {
    cat(i$pkg, '\n: ', i$details, '\n\n')
}

cat('\n\n### Contributed to\n\n')
for (i in output$rpackages$contributed) {
    cat(i$pkg, '\n: ', i$details, '\n\n')
}
