include .common_makefiles/common_makefile.mk
include .common_makefiles/shell_makefile.mk
include .common_makefiles/python_makefile.mk

REMOVE_DIST=0
EXTRA_PYTHON_FILES=dist/extra/python_forced_requirements_filter.py makefile_to_json.py
SRC_MAKEFILES=$(shell ls src/*.mk)
DIST_MAKEFILES=$(subst src/,dist/,$(SRC_MAKEFILES))
all:: devenv common.md shell.md python.md $(DIST_MAKEFILES) dist/extra.tar.gz

common.md: reference.md.j2 dist/common_makefile.mk
	$(ENTER_VENV) && export VAR=common && cat "$<" |envtpl >$@

shell.md: reference.md.j2 dist/shell_makefile.mk
	$(ENTER_VENV) && export VAR=shell && cat "$<" |envtpl >$@

python.md: reference.md.j2 dist/python_makefile.mk
	$(ENTER_VENV) && export VAR=python && cat "$<" |envtpl >$@

custom_clean::
	rm -Rf dist/*.mk dist/extra*

dist/%.mk: src/%.mk
	cp -f "$<" "$@"

dist/extra.tar.gz: src/extra
	rm -Rf dist/extra*
	cp -Rf "$<" dist/
	cd dist && tar -cf extra.tar extra && gzip -f extra.tar
	rm -Rf dist/extra