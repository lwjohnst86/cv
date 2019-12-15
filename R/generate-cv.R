generate_cv <- function() {
    generate_cv_pdf()
    generate_cv_html()
}

generate_cv_pdf <- function() {
    rmarkdown::render(
        input = here("vignettes", "cv.Rmd"),
        output_format = "vitae::awesomecv",
        encoding = "UTF-8",
        knit_root_dir = here(),
        output_dir = here("docs"),
        quiet = TRUE
    )
}

generate_cv_html <- function() {
    rmarkdown::render(
        input = here("vignettes", "cv.Rmd"),
        output_format = "pagedown::html_resume",
        encoding = "UTF-8",
        knit_root_dir = here(),
        output_dir = here("docs"),
        quiet = TRUE
    )
}
