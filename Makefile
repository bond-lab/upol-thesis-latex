# make             build the three examples
# make DOC=thesis  build thesis.pdf
EXAMPLES = example-kol example-kol-phd example-kol-phd-autoreferat
DOC ?=
LATEXMK = latexmk -lualatex -interaction=nonstopmode -halt-on-error

ifeq ($(DOC),)
all: $(EXAMPLES:=.pdf)
else
all: $(DOC).pdf
endif

example-kol-phd.pdf example-kol-phd-autoreferat.pdf: example-kol-phd-meta.tex

%.pdf: %.tex upolthesis.cls upolthesis-*.def
	$(LATEXMK) $*
	./upol-count.sh $*
	$(LATEXMK) -g $*

clean:
	latexmk -c $(or $(DOC),$(EXAMPLES))
	rm -f *.chars *.bbl *.run.xml

.PHONY: all clean
