RJwrapper.pdf: muschelli_FSLR.tex muschelli_FSLR.Rnw FSLR.bib 
	Rscript -e "library(knitr); knit('muschelli_FSLR.Rnw')"
	R CMD batch Parse_FSLRbib.R
	R CMD batch parse_body.R	
	pdflatex RJwrapper
	bibtex RJwrapper
	pdflatex RJwrapper
	pdflatex RJwrapper
	pdflatex RJwrapper
	open RJwrapper.pdf
