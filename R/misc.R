source('R/functions.R')
output <- yaml::yaml.load_file('_includes/misc.yaml')
output

cat('\n\n### CRAN packages\n\n')
for (i in output$rpackages$cran) {
    cat(i$pkg, '\n: ', i$details, '\n\n')
}

cat('\n\n### GitHub R packages\n\n')
for (i in output$rpackages$github) {
    cat(i$pkg, '\n: ', i$details, '\n\n')
}

cat('\n\n### R packages contributed to\n\n')
for (i in output$rpackages$contributed) {
    cat(i$pkg, '\n: ', i$details, '\n\n')
}

cat('\n\n### Programming languages\n\n')
cat('Competent\n: - ', paste0(output$skills$programming$competent, collapse = '\n\t- '), '\n\n')
cat('Familiar\n: - ', paste0(output$skills$programming$familiar, collapse = '\n\t- '), '\n\n')

cat('\n\n### Statistical techniques\n\n')
cat('Competent\n: - ', paste0(output$skills$statistics$competent, collapse = '\n\t- '), '\n\n')
cat('Familiar\n: - ', paste0(output$skills$statistics$familiar, collapse = '\n\t- '), '\n\n')
