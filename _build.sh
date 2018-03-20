#!/bin/sh

Rscript -e "rmarkdown::render_site('.', encoding = 'UTF-8')"
pandoc --variable=papersize:"letter" -V geometry:margin=2cm -V fontsize=12pt -V fontfamily=libertine index.md -o index.pdf
mv index.pdf cv-full-lukewjohnston.pdf
pandoc --variable=papersize:"letter" -V geometry:margin=2cm -V fontsize=12pt -V fontfamily=libertine recent.md -o recent.pdf
mv recent.pdf cv-recent-lukewjohnston.pdf

