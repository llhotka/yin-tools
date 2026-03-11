XSLT_DIR = .
MODULES =
DATE ?= $(shell date +%F)

yams = $(addsuffix .yang, $(MODULES))
xslpars = --stringparam date $(DATE)

.PHONY: all clean

all: $(yams)

%.yang: %.yinx
	@xsltproc $(XSLT_DIR)/canonicalize.xsl $< | \
	  xsltproc --output $@ $(xslpars) $(XSLT_DIR)/yin2yang.xsl -

clean:
	@rm -rf $(yams)
