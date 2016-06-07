suppressPackageStartupMessages(library(lubridate))
suppressPackageStartupMessages(library(yaml))

#' Order the data in the list by the end and start year.
#'
#' @param yaml_data The yaml data object.
#'
#' @return Outputs an ordered list.
order_by_year <- function(yaml_data) {
    ordering <- lapply(yaml_data, function(x) {
        if (is.null(x$end)) {
            x$end <- now()
        } else {
            x$end <- x$end
        }
        ymd(as_date(x$end))
    })

    if (is.null(yaml_data$start)) {
        ordered_output <-
            yaml_data[order(sapply(ordering, function(x)
                x[1]),
                decreasing = TRUE)]
    } else {
        ordered_output <-
            yaml_data[order(sapply(ordering, function(x)
                x[1]),
                sapply(yaml_data, function(x)
                    x$start),
                decreasing = TRUE)]
    }

    return(ordered_output)
}

#' Convert dates in yaml files to be 'monthname, year' type of format
#'
#' @param start List element name that contains the start time
#' @param end Like start, but for end time
#'
#' @return Outputs a string with month as abbrev and year
convert_date <- function(start, end = NULL) {
    start <- as_date(start)
    start_form <- paste0(month(start, label = TRUE), ', ', year(start))
    if (is.null(end)) {
            start_form
    } else if (!is.null(end)) {
        end <- as_date(end)
        end_form <- paste0(month(end, TRUE), ', ', year(end))
        start_form <- month(start, TRUE)
        if (month(start) == month(end) & year(start) == year(end)) {
            end_form
        } else if (year(start) == year(end)) {
            paste0(start_form, ' -- ', end_form)
        } else {
            start_form <- paste0(month(start, label = TRUE), ', ', year(start))
            paste0(start_form, ' -- ', end_form)
        }
    }
}

#' Generate a bibliography.
#'
#' @param publications Publication data list.
#' @param type Publication type, e.g. poster, articles
#'
#' @return Creates a list of references for each publication type.
publication_list <- function(publications, type = c('posters', 'orals', 'articles')) {
    type <- match.arg(type)
    output_file <- paste0('R/', type, '.Rmd')
    file_contents <- paste(
        '---',
        'bibliography: ../_includes/work.bib',
        'csl: ../_includes/style/ama.csl',
        'nocite: |\n',
        paste('  ', gsub('^(.*)$', '@\\1', publications), collapse = ', '),
        '---',
        sep = '\n'
    )
    writeLines(file_contents, con = output_file)
    rmarkdown::render(input = output_file, output_format = 'md_document',
                      quiet = TRUE)
    md_file <- paste0('R/', type, '.md')
    pub_list <- gsub('doi:', 'doi: ', readLines(md_file))
    pub_list <- gsub('(Johnston (L|LW))', '**\\1**', pub_list)
    pub_list <- paste(gsub('^$', '\n', pub_list), collapse = ' ')
    cat('\n\n', pub_list, '\n\n', sep = '\n')
}
