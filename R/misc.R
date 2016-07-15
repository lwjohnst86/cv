source('R/functions.R')
output <- yaml::yaml.load_file('_includes/misc.yaml')

cat('\n\n### Programming languages\n\n')
cat('Competent\n: - ', paste0(output$skills$programming$competent, collapse = '\n\t- '), '\n\n')
cat('Familiar\n: - ', paste0(output$skills$programming$familiar, collapse = '\n\t- '), '\n\n')

cat('\n\n### Statistical techniques\n\n')
cat('Competent\n: - ', paste0(output$skills$statistics$competent, collapse = '\n\t- '), '\n\n')
cat('Familiar\n: - ', paste0(output$skills$statistics$familiar, collapse = '\n\t- '), '\n\n')
