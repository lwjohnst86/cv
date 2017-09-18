pandoc -V title:"" --variable=papersize:"letter" -V geometry:margin=2cm -V fontsize=12pt -V fontfamily=libertine index.html -o index.pdf
pandoc -V title:"" --variable=papersize:"letter" -V geometry:margin=2cm -V fontsize=12pt -V fontfamily=libertine recent.html -o recent.pdf
