include .common_makefiles/common_makefile.mk

SHELLCHECK=AUTO
_SHELLCHECK_BIN=
SHELLCHECK_ARGS=
SHELLCHECK_URL=https://github.com/koalaman/shellcheck/releases/download/stable/shellcheck-stable.linux.x86_64.tar.xz
SHELLCHECK_FILES=$(shell find "$(ROOT_DIR)" -type f -name "*.sh" |xargs)
ifeq ($(SHELLCHECK),AUTO)
	SHELLCHECK_REQ=$(ROOT_TOOLS)/shellcheck
	_SHELLCHECK_BIN=$(ROOT_TOOLS)/shellcheck
else ifeq ($(SHELLCHECK),)
	SHELLCHECK_REQ=
	_SHELLCHECK_BIN=
else
	SHELLCHECK_REQ=
	_SHELLCHECK_BIN=$(shell which shellcheck)
endif

$(ROOT_TOOLS)/shellcheck:
	@mkdir -p "$(ROOT_TOOLS)" 
	@mkdir -p "$(ROOT_TMP)" 
	$(WGET) -O "$(ROOT_TMP)/shellcheck-stable.linux.x86_64.tar.xz" "$(SHELLCHECK_URL)"
	cd "$(ROOT_TMP)" && cat shellcheck-stable.linux.x86_64.tar.xz |tar xfJ - && cp -f shellcheck-stable/shellcheck $(ROOT_TOOLS)/shellcheck && rm -Rf shellcheck-stable shellcheck-stable.linux.x86_64.tar.xz

.PHONY: lint_shellcheck
lint_shellcheck: $(SHELLCHECK_REQ)
	@echo "Linting with shellcheck..."
	"$(_SHELLCHECK_BIN)" $(SHELLCHECK_ARGS) $(SHELLCHECK_FILES)

lint::
	@test -n "$(_SHELLCHECK_BIN)" && $(MAKE) lint_shellcheck

_debug::
	@echo "SHELLCHECK=$(SHELLCHECK)"
	@echo "_SHELLCHECK_BIN=$(_SHELLCHECK_BIN)"
	@echo "SHELLCHECK_URL=$(SHELLCHECK_URL)"
