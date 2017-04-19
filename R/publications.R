source('R/functions.R')
output <- yaml::yaml.load_file('_includes/publications.yaml')[[1]]

cat('\n\n### Articles\n\n')
publication_list(output$articles, 'articles')
cat('\n\n### Oral presentations\n\n')
publication_list(output$orals, 'orals')
cat('\n\n### Poster presentation\n\n')
publication_list(output$posters, 'posters')
cat('\n\n### Panel member\n\n')
publication_list(output$panel, 'panel')

