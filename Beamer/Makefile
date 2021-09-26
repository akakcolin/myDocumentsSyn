all: main.pdf

%.pdf: %.tex
	xelatex -synctex=1 -interaction=nonstopmode $<
	xelatex -synctex=1 -interaction=nonstopmode $<

.PHONY: clean upgrade
clean:
	find . -maxdepth 1 \
		\( -name "*.aux" -o -name "*.bbl" -o -name "*.blg" -o \
	           -name "*.log" -o -name "*.out" -o -name "*.pdf" -o \
		   -name "*.nav" -o -name "*.snm" -o -name "*.toc" -o \
		   -name "*.vrb" -o -name "*.synctex.gz" \) | xargs $(RM)

upgrade:
