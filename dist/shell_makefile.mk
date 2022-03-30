#* shellcheck linter configuration:
#* AUTO    => auto-download shellcheck tool
#* (empty) => disable shellcheck linter
#* (path)  => disable auto-download and use this binary
SHELLCHECK?=AUTO

_SHELLCHECK_BIN=

#+ shellcheck linter extra options
SHELLCHECK_ARGS?=

#+ shellcheck download url
SHELLCHECK_URL?=https://github.com/koalaman/shellcheck/releases/download/stable/shellcheck-stable.linux.x86_64.tar.xz

#+ shellcheck files to check
#+ (by default, all *.sh files are checked)
SHELLCHECK_FILES?=$(shell find "$(ROOT_DIR)" -type f -name "*.sh" |grep -v "^$(ROOT_DIR)/\.tools/" |grep -v "^$(ROOT_DIR)/\.tmp/" |grep "[a-zA-Z0-9]" |xargs)

ifeq ($(SHELLCHECK),AUTO)
	DEVENV_PREREQ+=$(ROOT_TOOLS)/shellcheck
	_SHELLCHECK_BIN=$(ROOT_TOOLS)/shellcheck
else ifeq ($(SHELLCHECK),)
	_SHELLCHECK_BIN=
else
	_SHELLCHECK_BIN=$(shell which $(SHELLCHECK))
endif

$(ROOT_TOOLS)/shellcheck:
	$(call header2,Installing shellcheck...)
	@mkdir -p "$(ROOT_TOOLS)"
	@mkdir -p "$(ROOT_TMP)"
	$(WGET) -O "$(ROOT_TMP)/shellcheck-stable.linux.x86_64.tar.xz" "$(SHELLCHECK_URL)"
	cd "$(ROOT_TMP)" && cat shellcheck-stable.linux.x86_64.tar.xz |tar xfJ - && cp -f shellcheck-stable/shellcheck $(ROOT_TOOLS)/shellcheck && rm -Rf shellcheck-stable shellcheck-stable.linux.x86_64.tar.xz
	cd "$(ROOT_TMP)" && rm -Rf shellcheck*
	$(call header2,shellcheck installed)

_remove_devenv::
	rm -Rf $(ROOT_TOOLS)/shellcheck

.PHONY: lint_shellcheck
lint_shellcheck:
	@echo "Linting with shellcheck..."
	"$(_SHELLCHECK_BIN)" $(SHELLCHECK_ARGS) $(SHELLCHECK_FILES)

_lint::
	@test -n "$(_SHELLCHECK_BIN)" && test -n "$(SHELLCHECK_FILES)" && $(MAKE) lint_shellcheck

_debug::
	@echo "SHELLCHECK=$(SHELLCHECK)"
	@echo "_SHELLCHECK_BIN=$(_SHELLCHECK_BIN)"
	@echo "SHELLCHECK_URL=$(SHELLCHECK_URL)"
	@echo "SHELLCHECK_FILES=$(SHELLCHECK_FILES)"
