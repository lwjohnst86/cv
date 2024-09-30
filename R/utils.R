output <- function(.object, compact = FALSE, from_bib = FALSE, caption = NULL) {
  if (knitr::is_html_output()) {
    if (from_bib) {
      cat(.object, sep = "\n")
    } else {
      .object <- .object |>
        ungroup()

      if (!"where" %in% names(.object)) {
        .object <- .object |>
          dplyr::mutate(where = "")
      } else {
        .object <- .object |>
          dplyr::mutate(where = if_else(is.na(where), "",
            as.character(glue::glue("in {where}"))
          ))
      }
      .output_html_item(.object, caption = caption)
    }
  } else if (interactive()) {
    .object
  }
}

.output_html_item <- function(data, caption) {
  data |>
    dplyr::transmute(
      when = when,
      what = glue::glue("{what}, {with} {where}")
    ) |>
    knitr::kable(col.names = NULL, align = "ll", caption = caption, label = NA)
}

#' Tidy up date variables.
#'
#' @param data Dataset to tidy with `start` and `end` date variables.
#'
#' @return A [tibble::tibble()] dataset with tidied date variables.
#' @export
#'
tidy_dates <- function(data) {
  data |>
    dplyr::arrange(dplyr::desc(is.na(end)), dplyr::desc(start)) |>
    dplyr::mutate(
      start = lubridate::year(start),
      end = lubridate::year(end),
      end = dplyr::if_else(is.na(end), "present", as.character(end)),
      date_range = dplyr::if_else(start == end, glue("{start}"), glue("{start} -- {end}"))
    )
}
