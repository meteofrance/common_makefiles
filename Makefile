# python interpreter configuration:
# AUTO_3_8    => auto-download python 3.8
# AUTO_3_9    => auto-download python 3.9
# AUTO_3_10   => auto-download python 3.10
PYTHON=AUTO_3_10

-include .common_makefiles/common_makefile.mk
-include .common_makefiles/shell_makefile.mk
-include .common_makefiles/python_makefile.mk

REMOVE_DIST=0
export REFERENCE=docs/90-reference
APP_DIRS=common_makefiles
TEST_DIRS=tests
SRC_MAKEFILES=$(shell ls src/*.mk)
REF_MAKEFILES=$(subst .mk,.md,$(addprefix $(REFERENCE)/,$(subst src/,,$(SRC_MAKEFILES))))
DIST_MAKEFILES=$(subst src/,dist/,$(SRC_MAKEFILES))
BOOTSTRAP=dist/extra.tar.gz $(DIST_MAKEFILES)
all:: $(BOOTSTRAP) $(REFERENCE)/makefile_to_json.py $(REF_MAKEFILES)

.PHONY: bootstrap
bootstrap: $(BOOTSTRAP)

dist/%.mk: src/%.mk
	cat "$<" |./tools/envtpl-static >"$@"

dist/extra.tar.gz: src/extra
	rm -Rf dist/extra*
	cp -Rf "$<" dist/
	cd dist && tar --dereference -cf extra.tar extra && gzip -f extra.tar
	rm -Rf dist/extra

$(REFERENCE)/makefile_to_json.py: common_makefiles/makefile_to_json.py
	cp -f "$<" "$@"
	chmod +x "$@" 

$(REFERENCE)/%.md: $(REFERENCE)/reference.md.j2 dist/%.mk
	T=$$(echo $^ |cut -f2 -d' ') && export MAKEFILE=$$(basename "$${T}") && cat "$<" |./tools/envtpl-static >"$@"

custom_clean::
	rm -f $(REFERENCE)/*.md $(REFERENCE)/*.py

custom_distclean::
	rm -Rf dist/*

.PHONY: htmldoc serve_htmldoc
htmldoc: devenv $(REFERENCE)/makefile_to_json.py $(REF_MAKEFILES)
	$(ENTER_VENV) && mkdocs build
serve_htmldoc: $(REFERENCE)/makefile_to_json.py $(REF_MAKEFILES)
	$(ENTER_VENV) && mkdocs serve