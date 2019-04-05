.PHONY: all clean view

paper_name=gp
master_tex=${paper_name}.tex

tex_sources=${shell ls *.tex}
#bibf=reference.bib
#pdf_output=paper.pdf

all: pdf_output

once: clean ${tex_source} ${bibf}
	xelatex ${master_tex}

#TODO: 在编译结束以后使用了grep来显示出错的地方，但是
#如果不存在出错的话grep会返回一个错误，导致make停止。
#虽然可以使用减号前缀让make继续，但是仍然会显示一个错误
#信息。有没有什么办法让make闭嘴？
pdf_output: ${tex_source} ${bibf}
	#./tangle ${master_tex} code >dftb.lisp
	xelatex ${master_tex}
	bibtex  ${paper_name}.aux
	xelatex ${master_tex}
	bibtex  ${paper_name}.aux
	xelatex ${master_tex}
	xelatex ${master_tex}

clean:
	rm -f *.aux *.pdf *.bbl *.blg *.log *.toc *.out *.lof *.lot
