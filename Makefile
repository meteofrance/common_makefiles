include .common_makefiles/common_makefile.mk
include .common_makefiles/shell_makefile.mk
include .common_makefiles/python_makefile.mk

REMOVE_DIST=0
EXTRA_PYTHON_FILES=dist/extra/python_forced_requirements_filter.py makefile_to_json.py

all:: common.md shell.md python.md

common.md: reference.md.j2 dist/common_makefile.mk
	$(ENTER_VENV) && export VAR=common && cat "$<" |envtpl >$@

shell.md: reference.md.j2 dist/shell_makefile.mk
	$(ENTER_VENV) && export VAR=shell && cat "$<" |envtpl >$@

python.md: reference.md.j2 dist/python_makefile.mk
	$(ENTER_VENV) && export VAR=python && cat "$<" |envtpl >$@
