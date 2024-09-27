# This function could be used to generate also pdf (TODO)
generate_cv <- function() {
  generate_cv_html()
}

generate_cv_html <- function() {
  rmarkdown::render_site(
    input = here("vignettes"),
    output_format = "distill::distill_article",
    encoding = "UTF-8",
    quiet = TRUE
  )
  fs::file_delete(here("public/cv.html"))
}

# webshot::webshot("https://cv.lukewjohnston.com/", "cv.pdf") #?
