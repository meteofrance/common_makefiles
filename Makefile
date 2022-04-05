# python interpreter configuration:
# AUTO_3_8    => auto-download python 3.8
# AUTO_3_9    => auto-download python 3.9
# AUTO_3_10   => auto-download python 3.10
PYTHON=AUTO_3_10

include .common_makefiles/common_makefile.mk
include .common_makefiles/shell_makefile.mk
include .common_makefiles/python_makefile.mk

REMOVE_DIST=0
export REFERENCE=docs/90-reference
EXTRA_PYTHON_FILES=src/extra/python_forced_requirements_filter.py $(REFERENCE)/makefile_to_json.py
SRC_MAKEFILES=$(shell ls src/*.mk)
REF_MAKEFILES=$(subst .mk,.md,$(addprefix $(REFERENCE)/,$(subst src/,,$(SRC_MAKEFILES))))
DIST_MAKEFILES=$(subst src/,dist/,$(SRC_MAKEFILES))
all:: $(DIST_MAKEFILES) dist/extra.tar.gz

$(REFERENCE)/common_makefile.md: $(REFERENCE)/reference.md.j2 dist/common_makefile.mk
	$(ENTER_VENV) && export VAR=common && cat "$<" |envtpl >$@

$(REFERENCE)/shell_makefile.md: $(REFERENCE)/reference.md.j2 dist/shell_makefile.mk
	$(ENTER_VENV) && export VAR=shell && cat "$<" |envtpl >$@

$(REFERENCE)/python_makefile.md: $(REFERENCE)/reference.md.j2 dist/python_makefile.mk
	$(ENTER_VENV) && export VAR=python && cat "$<" |envtpl >$@

custom_clean::
	rm -Rf dist/*.mk dist/extra*
	rm -f $(REFERENCE)/*.md

dist/%.mk: src/%.mk
	cp -f "$<" "$@"

dist/extra.tar.gz: src/extra
	rm -Rf dist/extra*
	cp -Rf "$<" dist/
	cd dist && tar -cf extra.tar extra && gzip -f extra.tar
	rm -Rf dist/extra

.PHONY: htmldoc serve_htmldoc
htmldoc: devenv $(REF_MAKEFILES)
	$(ENTER_VENV) && mkdocs build
serve_htmldoc: $(REF_MAKEFILES)
	$(ENTER_VENV) && mkdocs serve