MODULES =
DATE ?= $(shell date +%F)

yams = $(addsuffix .yang, $(MODULES))
xslpars = --stringparam date $(DATE)

.PHONY: all clean

all: $(yams)

%.yang: %.yinx
	@xsltproc canonicalize.xsl $< | \
	  xsltproc --output $@ $(xslpars) yin2yang.xsl -

clean:
	@rm -rf $(yams)
