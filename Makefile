VERSION = 1.0.0

.PHONY: all rnc

all: rnc release

rnc:
	$(MAKE) -C schema all

release:
	git tag -a -s -m "YIN Tools release v$(VERSION)" "v$(VERSION)"
	git push --follow-tags
