XSLTOPTS = --stringparam html.stylesheet style.css \
           --stringparam  chapter.autolabel 1 \
           --stringparam  appendix.autolabel A \
           --stringparam  section.autolabel 1 \
           --stringparam  section.label.includes.component.label 1 \
         --xinclude

##
# These URI should be rewritten by your distribution's xml catalog to
# match your localy installed XSL stylesheets.
XSL_BASE_URI  = http://docbook.sourceforge.net/release/xsl/current
XSL_XHTML_URI = $(XSL_BASE_URI)/xhtml/docbook.xsl

all: html pdf tarball

pdf:
	../tools/poky-docbook-to-pdf adt-manual.xml ../template

##
# These URI should be rewritten by your distribution's xml catalog to
# match your localy installed XSL stylesheets.

html:
#       See http://www.sagehill.net/docbookxsl/HtmlOutput.html 

#	xsltproc $(XSLTOPTS) -o adt-manual.html $(XSL_XHTML_URI) adt-manual.xml
	xsltproc $(XSLTOPTS) -o adt-manual.html adt-manual-customization.xsl adt-manual.xml

tarball: html
	tar -cvzf adt-manual.tgz adt-manual.html adt-manual.pdf style.css figures/adt-title.png

validate:
	xmllint --postvalid --xinclude --noout adt-manual.xml

MANUALS = adt-manual.html adt-manual.pdf
FIGURES = figures/*.png
STYLESHEET = *.css

publish:
	scp -r $(MANUALS) $(STYLESHEET) www.yoctoproject.org:/srv/www/www.yoctoproject.org-docs/adt-manual
	scp -r $(FIGURES) www.yoctoproject.org:/srv/www/www.yoctoproject.org-docs/adt-manual/figures

clean:
	rm -f $(MANUALS)
