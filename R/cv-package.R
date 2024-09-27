#' @keywords internal
#' @import dplyr
#' @importFrom here here
#' @importFrom glue glue glue_data
#' @importFrom lubridate ymd as_date year
"_PACKAGE"

# The following block is used by usethis to automatically manage
# roxygen namespace tags. Modify with care!
## usethis namespace: start
#' @importFrom tibble tibble
## usethis namespace: end
NULL

#' @title List sections for a CV.
#'
#' @name list_sections
#' @param data CV data.
#'
#' @return Depending on output type, returns:
#'
#'   - a [tibble::tibble()] if used interactively
#'   - a TeX listing of the section items if used when the output document is a
#'   PDF from the [vitae] package
#'   - a markdown listing of the section items if used when the output document
#'   is a HTML file from the [pagedown] package
#'
NULL
