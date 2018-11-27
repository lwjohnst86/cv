suppressPackageStartupMessages(library(lubridate))
suppressPackageStartupMessages(library(yaml))
suppressPackageStartupMessages(library(glue))

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
    start <- as_date(start, tz = "UTC", format = "%F")
    # start_form <- as.character(start)
    start_form <- paste0(month(start, label = TRUE), ', ', year(start))
    if (is.null(end)) {
            start_form
    } else if (!is.null(end)) {
        end <- as_date(end, tz = "UTC", format = "%F")
        # end_form <- as.character(end)
        end_form <- paste0(month(end, TRUE), ', ', year(end))
        if (month(start) == month(end) & year(start) == year(end)) {
            end_form
        } else if (year(start) == year(end)) {
            start_form <- month(start, TRUE)
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
publication_list <- function(publications, type = c('posters', 'orals', 'articles', 'panel', "otherconf", "posterpres")) {
    type <- match.arg(type)
    output_file <- paste0('R/', type, '.Rmd')
    years_to_keep <- getOption("restrict_to_year")
    if (!is.null(years_to_keep)) {
        years_to_keep <- year(Sys.Date()):years_to_keep
        years_to_keep <- paste0(years_to_keep, collapse = "|")
        publications <- grep(years_to_keep, publications, value = TRUE)
    }
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

#' Limit the CV entries to a certain number of years from the past
#'
#' @param cv_entry The CV section list
#'
#' @return Outputs TRUE to exclude the entry, FALSE to include
restricted_entry <- function(cv_entry) {
    restricted_year <- getOption("restrict_to_year")
    start <- cv_entry$start
    end <- cv_entry$end

    if (is.null(restricted_year))
        return(FALSE)

    if (!is.null(start) & is.null(end)) {
        if (nchar(start) == 4) {
            start <- as_date(paste0(start, '-01-01'))
        } else {
            start <- as_date(start)
        }
        year(start) < restricted_year
    } else if (!is.null(end)) {
        if (nchar(end) == 4) {
            end <- as_date(paste0(end, '-01-01'))
        } else {
            end <- as_date(end)
        }
        year(end) < restricted_year
    }
}

