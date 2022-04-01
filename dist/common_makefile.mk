# makefile configuration
# see https://www.gnu.org/software/make/manual/html_node/Special-Targets.html
.DELETE_ON_ERROR:
.SECONDEXPANSION:
.DEFAULT_GOAL: default
SHELL=/bin/bash

# Utils
LINTER=$(_EXTRA)/linter.sh
REFORMATER=$(_EXTRA)/reformater.sh
CHECKER=$(_EXTRA)/checker.sh
HEADER1=$(_EXTRA)/header1.sh
HEADER2=$(_EXTRA)/header2.sh
HEADER3=$(_EXTRA)/header3.sh
HEADER4=$(_EXTRA)/header4.sh

#+ Binary to use for git
GIT?=git

#+ Binary to use for wget
WGET?=wget

#+ Common makefiles git url (for refresh_makefiles target)
COMMON_MAKEFILES_GIT_URL?=http://github.com/meteofrance/common_makefiles.git

#+ Common makefiles git branch (for refresh_makefiles target)
COMMON_MAKEFILES_GIT_BRANCH?=main

_GIT_CLONE_DEPTH_1=$(GIT) clone --depth 1
_GIT_CHECKOUT_BRANCH=if test "$(COMMON_MAKEFILES_GIT_BRANCH)" != "main"; then $(GIT) checkout $(COMMON_MAKEFILES_GIT_BRANCH); fi

## Directory containing the "Makefile" (probably the root directory of the project)
ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

## Temporary directory (local to the project)
ROOT_TMP=$(ROOT_DIR)/.tmp

## Tools directory (local to the project)
ROOT_TOOLS=$(ROOT_DIR)/.tools

_EXTRA=$(ROOT_TOOLS)/common_makefiles_extra

## Common makefiles directory
ROOT_COMMON=$(ROOT_DIR)/.common_makefiles

#+ Devenv flag file (if it exists, the dev env is set up)
DEVENV_FILE?=$(ROOT_DIR)/.devenv

#+ Runenv flag file (if it exists, the run env is set up)
RUNENV_FILE?=$(ROOT_DIR)/.runenv

#+ Devenv prerequisite list (use += to add some targets)
DEVENV_PREREQ?=
_DEVENV_PREREQ=
ifneq ("$(wildcard $(RUNENV_FILE))","")
    _DEVENV_PREREQ+=remove_runenv
endif
ifeq ("$(wildcard $(DEVENV_FILE))","")
    _DEVENV_PREREQ+=before_devenv
endif

#+ Runenv prerequisite list (use += to add some targets)
RUNENV_PREREQ?=
_RUNENV_PREREQ=
ifneq ("$(wildcard $(DEVENV_FILE))","")
    _RUNENV_PREREQ+=remove_devenv _after_remove_devenv
endif
ifeq ("$(wildcard $(RUNENV_FILE))","")
    _RUNENV_PREREQ+=before_runenv
endif

.PHONY: default
default:: _make_help_banner all

.PHONY: _make_help_banner
_make_help_banner:
	@echo "Executing default all target (use 'make help' to show other targets/options)"

.PHONY: all before_all
_ALL_PREREQ=runenv
ifneq ("$(wildcard $(DEVENV_FILE))","")
    _ALL_PREREQ=devenv
endif
all:: before_all $(_ALL_PREREQ)
before_all:: $(EXTRA_PREREQ)

EXTRA_PREREQ=$(ROOT_TOOLS)/common_makefiles_extra/common.sh
ifneq ("$(wildcard $(ROOT_COMMON)/extra.tar.gz)","")
	_EXTRA_PREREQ=$(ROOT_COMMON)/extra.tar.gz
else
    _EXTRA_PREREQ=$(ROOT_COMMON)/extra
endif
$(ROOT_TOOLS)/common_makefiles_extra/common.sh: $(_EXTRA_PREREQ)
	@rm -Rf "$(ROOT_TOOLS)/common_makefiles_extra"
	@mkdir -p "$(ROOT_TOOLS)"
	@if test -f "$<"; then mkdir -p "$(ROOT_TOOLS)/common_makefiles_extra" && cd "$(ROOT_TOOLS)/common_makefiles_extra" && zcat "$<" |tar xf - && cd extra && mv * .. && cd .. && rm -Rf extra; else ln -s "$<" "$(ROOT_TOOLS)/common_makefiles_extra"; fi
	@touch "$@"

.PHONY: help
help::
	@mkdir -p "$(ROOT_TMP)"
	@# See https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
	@cat $(MAKEFILE_LIST) >"$(ROOT_DIR)/.tmp/help.txt"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' "$(ROOT_DIR)/.tmp/help.txt" | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@rm -f "$(ROOT_DIR)/.tmp/help.txt"

.PHONY: devenv before_devenv remove_devenv _after_remove_devenv before_remove_devenv custom_remove_devenv _remove_devenv
devenv: $(EXTRA_PREREQ) $(DEVENV_FILE) ## Prepare dev environment
$(DEVENV_FILE): $$(_DEVENV_PREREQ) $$(DEVENV_PREREQ)
	@$(HEADER1) "devenv is ready"
	@touch "$@"
before_devenv::
	@$(HEADER1) "Building devenv"
remove_devenv: before_remove_devenv _remove_devenv custom_remove_devenv _after_remove_devenv
_remove_devenv::
before_remove_devenv::
	@$(HEADER2) "Removing devenv"
custom_remove_devenv::
	@$(HEADER2) "Calling custom_remove_devenv"
_after_remove_devenv:
	@rm -f $(DEVENV_FILE)
	@$(HEADER2) "Devenv removed"

.PHONY: runenv before_runenv remove_runenv _after_remove_runenv before_remove_runenv custom_remove_runenv _remove_runenv
runenv: $(EXTRA_PREREQ) $(RUNENV_FILE) ## Prepare run environment
$(RUNENV_FILE): $$(_RUNENV_PREREQ) $$(RUNENV_PREREQ)
	@$(HEADER1) "runenv is ready"
	@touch "$@"
before_runenv::
	@$(HEADER1) "Building runenv"
remove_runenv: before_remove_runenv _remove_runenv custom_remove_runenv _after_remove_runenv
_remove_runenv::
before_remove_runenv::
	@$(HEADER2) "Removing runenv"
custom_remove_runenv::
	@$(HEADER2) "Calling custom_remove_runenv"
_after_remove_runenv:
	@rm -f $(RUNENV_FILE)
	@$(HEADER2) "Runenv removed"

.PHONY: lint before_lint custom_lint _after_lint _lint
lint: $(EXTRA_PREREQ) before_lint _lint custom_lint _after_lint ## Lint the code
#+ target executed before linting
before_lint:: devenv
	@$(HEADER1) "Linting"
	@$(HEADER2) "Calling before_lint target"
_lint::
	@$(HEADER2) "Common linting"
#+ custom linting target
custom_lint::
	@$(HEADER2) "Calling custom_lint target"
_after_lint:
	@$(HEADER1) "Linting OK"

.PHONY: reformat before_reformat custom_reformat _after_reformat _reformat
reformat: $(EXTRA_PREREQ) before_reformat _reformat custom_reformat _after_reformat ## Reformat sources and tests
#+ target executed before reformating
before_reformat:: devenv
	@$(HEADER1) "Reformating"
	@$(HEADER2) "Calling before_reformat target"
_reformat::
	@$(HEADER2) "Common reformating"
#+ custom reformating target
custom_reformat::
	@$(HEADER2) "Calling custom_lint target"
_after_reformat:
	@$(HEADER1) "Reformating OK"

.PHONY: clean before_clean _clean _after_clean custom_clean
clean: $(EXTRA_PREREQ) before_clean _clean custom_clean _after_clean ## Clean build and temporary files
#+ target executed before cleaning
before_clean::
	@$(HEADER1) "Cleaning"
	@$(HEADER2) "Calling before_clean target"
_clean:: remove_devenv remove_runenv
	@$(HEADER2) "Common cleaning"
	rm -Rf .refresh_makefiles.tmp "$(ROOT_TMP)"
	rm -f "$(DEVENV_FILE)" "$(RUNENV_FILE)"
#+ custom reformating target
custom_clean::
	@$(HEADER2) "Calling custom_clean target"
_after_clean:
	@$(HEADER1) "Cleaning OK"

.PHONY: distclean
distclean: $(EXTRA_PREREQ) clean ## Full clean (including common_makefiles downloaded tools)
	@$(HEADER1) "Cleaning common_makefiles tools"
	rm -Rf "$(ROOT_TOOLS)"
	@$(HEADER1) "Cleaning common_makefiles tools OK"

.PHONY: check before_check custom_check _after_check _check tests
check: $(EXTRA_PREREQ) before_check _check custom_check _after_check ## Execute tests
#+ target executed before tests
before_check:: devenv
	@$(HEADER1) "Executing checks"
	@$(HEADER2) "Calling before_check target"
_check::
	@$(HEADER2) "Common checks"
#+ custom check target
custom_check::
	@$(HEADER2) "Calling custom_check target"
_after_check:
	@$(HEADER1) "Checks OK"
## Simple alias for "check" target
tests: check

.PHONY: refresh before_refresh custom_refresh _after_refresh _refresh refresh_common_makefiles
refresh: $(EXTRA_PREREQ) before_refresh _refresh custom_refresh _after_refresh ## Refresh all things
before_refresh::
	@$(HEADER1) "Refreshing"
	@$(HEADER2) "Calling before_refresh target"
_refresh::
	@$(HEADER2) "Common refreshing"
_refresh:: refresh_common_makefiles
custom_refresh::
	@$(HEADER2) "Calling custom_refresh target"
_after_refresh:
	@$(HEADER1) "Refresh OK"
refresh_common_makefiles: ## Refresh common makefiles from repository
	@$(HEADER2) "Refreshing common makefiles"
	rm -Rf .refresh_makefiles.tmp && mkdir -p .refresh_makefiles.tmp
	cd .refresh_makefiles.tmp && $(_GIT_CLONE_DEPTH_1) $(COMMON_MAKEFILES_GIT_URL) && $(_GIT_CHECKOUT_BRANCH) && rm -Rf ../.common_makefiles && mv common_makefiles/dist ../.common_makefiles
	rm -Rf .refresh_makefiles.tmp
	@$(HEADER2) "common makefiles refreshed"

.PHONY: coverage_console before_coverage_console _coverage_console custom_coverage_console _after_coverage_console
coverage_console: $(EXTRA_PREREQ) before_coverage_console _coverage_console custom_coverage_console _after_coverage_console ## Execute unit-tests and show coverage on console
#+ target executed before coverage_console
before_coverage_console:: devenv
	@$(HEADER1) "Coveraging (console)"
	@$(HEADER2) "Calling before_coverage_console target"
_coverage_console::
	@$(HEADER2) "Common coveraging (console)"
#+ custom coverage_console target
custom_coverage_console::
	@$(HEADER2) "Calling custom_coverage_console target"
_after_coverage_console:
	@$(HEADER1) "Coveraging (console) OK"

.PHONY: coverage
## simple alias to coverage_console
coverage: coverage_console

.PHONY: coverage_html before_coverage_html _coverage_html custom_coverage_html _after_coverage_html
coverage_html: $(EXTRA_PREREQ) before_coverage_html _coverage_html custom_coverage_html _after_coverage_html ## Execute unit-tests and show coverage in html
#+ target executed before coverage_html
before_coverage_html:: devenv
	@$(HEADER1) "Coveraging (html)"
	@$(HEADER2) "Calling before_coverage_html target"
_coverage_html::
	@$(HEADER2) "Common coveraging (html)"
#+ custom coverage_html target
custom_coverage_html::
	@$(HEADER2) "Calling custom_coverage_html target"
_after_coverage_html:
	@$(HEADER1) "Coveraging (html) OK"

.PHONY: coverage_sonar before_coverage_sonar _coverage_sonar custom_coverage_sonar _after_coverage_sonar
coverage_sonar: $(EXTRA_PREREQ) before_coverage_sonar _coverage_sonar custom_coverage_sonar _after_coverage_sonar ## Execute unit-tests and compute coverage for sonarqube
#+ target executed before coverage_sonar
before_coverage_sonar:: devenv
	@$(HEADER1) "Coveraging (sonar)"
	@$(HEADER2) "Calling before_coverage_sonar target"
_coverage_sonar::
	@$(HEADER2) "Common coveraging (sonar)"
#+ custom coverage_sonar target
custom_coverage_sonar::
	@$(HEADER2) "Calling custom_coverage_sonar target"
_after_coverage_sonar:
	@$(HEADER1) "Coveraging (sonar) OK"

.PHONY: coverage_xml
## simple alias of coverage_sonar target
coverage_xml: coverage_sonar

.PHONY: _debug
_debug:: ## Dump common_makefiles configuration
	@echo "COMMON_MAKEFILES_GIT_URL=$(COMMON_MAKEFILES_GIT_URL)"
	@echo "GIT=$(GIT)"
	@echo "WGET=$(WGET)"
	@echo "MAKEFILE_LIST=$(MAKEFILE_LIST)"
	@echo "ROOT_DIR=$(ROOT_DIR)"
	@echo "ROOT_TMP=$(ROOT_TMP)"
	@echo "ROOL_TOOLS=$(ROOT_TOOLS)"
	@echo "DEVENV_PREREQ=$(DEVENV_PREREQ)"
	@echo "RUNENV_PREREQ=$(RUNENV_PREREQ)"