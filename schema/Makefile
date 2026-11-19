MODULE =

.PHONY: all clean validate

all: yin.rnc yin-html.rnc

%.rnc: %.rng
	trang -I rng -O rnc $< $@

validate: $(MODULE)
	jing yin-html.rng $<

clean:
	rm -f *.rnc
