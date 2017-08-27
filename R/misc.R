source('R/functions.R')
output <- yaml::yaml.load_file('_includes/misc.yaml')

cat('\n\n### Programming languages\n\n')
cat('**Competent**\n\n- ', paste0(output$skills$programming$competent, collapse = '\n- '), '\n\n')
cat('**Familiar**\n\n- ', paste0(output$skills$programming$familiar, collapse = '\n- '), '\n\n')

cat('\n\n### Statistical techniques\n\n')
cat('**Competent**\n\n- ', paste0(output$skills$statistics$competent, collapse = '\n- '), '\n\n')
cat('**Familiar**\n\n- ', paste0(output$skills$statistics$familiar, collapse = '\n- '), '\n\n')
