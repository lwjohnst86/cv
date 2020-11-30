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
    rmarkdown::render_site(
        input = here("vignettes"),
        output_format = "distill::distill_article",
        encoding = "UTF-8",
        quiet = TRUE
    )
    fs::file_delete(here("docs/cv.html"))
}
