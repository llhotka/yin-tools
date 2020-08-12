# YIN Tools

This repository contains various tools that aids in editing, processing and validating YANG modules in the alternative XML syntax named [YIN](https://tools.ietf.org/html/rfc7950#section-13).

## RELAX NG schemas

The `schema` directory contains two RELAX NG schemas:

* [yin.rng](schema/yin.rng] – schema of the standard YIN syntax
* [yin-html.rng](schema/yin-html.rng) – YIN with [HTML-like markup extensions](#html-like-extensions-to-yin).

The RELAX NG schema can be used for validating a YANG module (in the YIN syntax, of course). The `validate` target of the included [Makefile](schema/Makefile) shows how it can be done with the [Jing](https://relaxng.org/jclark/jing.html) tool.

The schemas can also be used with schema-aware XML editors, such as [oXygen](https://www.oxygenxml.com/xml_editor.html) or Emacs with [nXML mode](https://www.gnu.org/software/emacs/manual/html_node/nxml-mode), to provide on-the-fly validation, YANG statement completion and other neat features.

Some XML tools can only work with the RELAX NG compact syntax. The latter can be obtained by running
``` shell
make
```
in the `schema` directory (provided that [trang](https://relaxng.org/jclark/trang.html) is instaled),

## XSLT stylesheets

The `xslt` directory contains the following XSLT stylesheets:

* [canonicalize.xsl](xslt/canonicalize.xsl) – rearrange a YANG module or submodule so that all its statements are in the [canonical order](https://tools.ietf.org/html/rfc7950#section-14)
* [getrev.xsl](xslt/getrev.xsl) – extract the date of the latest revision of a (sub)module
* [yin2yang.xsl](yin2yang.xsl) – convert a (sub)module, optionally with [HTML-like markup extensions](#html-like-extensions-to-yin), to the compact YANG syntax.

The included [Makefile](xslt/Makefile) can be used for converting any number of (sub)modules in the extended YIN syntax (hence with the `.yinx` extension) to the compact YANG syntax, while also

* canonicalizing the order of statements, and
* using the current date for the latest revision of each (sub)module.

## HTML-like extensions to YIN

Arguments of some YANG statements often contain longer text containing multiple paragraphs, bulleted lists etc. Maintaining such text structures without any markup is difficult and error prone. RELAX NG schema [yin-html.rng](schema/yin-html.rng) and XSLT stylesheets therefore support the following XML elements in the XHTML namespace (`http://www.w3.org/1999/xhtml`) as an extension to the standard YIN syntax:

* `<p>` – paragraph of text
* `<br>` – unconditional line break inside a paragraph
* `<ul>` – unordered list
* `<ol>` – ordered list
* `<li>` - list item

The `<p>`, `<ul>` and `<ol>` elements are only permitted as children of the YIN `<text>` element, i.e. inside arguments of the following YANG statements: **contact**, **description**, **error-message** and **organization**.

In order to distinguish this extended syntax from the original YIN syntax, it is recommended to use the `.yinx` extension for files containing such modules.
