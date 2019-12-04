generate_cv <- function() {
    # PDF
    rmarkdown::render(
        input = here("vignettes", "cv.Rmd"),
        output_format = "vitae::awesomecv",
        output_dir = here("docs"),
        quiet = TRUE
    )

    # HTML
    rmarkdown::render(
        input = here("vignettes", "cv.Rmd"),
        output_format = "pagedown::html_resume",
        output_dir = here("docs"),
        quiet = TRUE
    )
}

