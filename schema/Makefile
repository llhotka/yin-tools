MODULE =

.PHONY: all clean validate

all: yin-html.rnc

%.rnc: %.rng
	trang -I rng -O rnc $< $@

validate: $(MODULE)
	jing yin-html.rng $<

clean:
	rm -f *.rnc
