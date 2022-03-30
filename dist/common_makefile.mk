# makefile configuration
# see https://www.gnu.org/software/make/manual/html_node/Special-Targets.html
.DELETE_ON_ERROR:
.SECONDEXPANSION:
.DEFAULT_GOAL: default
SHELL=/bin/bash

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

## Common makefiles directory
ROOT_COMMON=$(ROOT_DIR)/.common_makefiles

#+ Devenv flag file (if it exists, the dev env is set up)
DEVENV_FILE?=$(ROOT_DIR)/.devenv

#+ Runenv flag file (if it exists, the run env is set up)
RUNENV_FILE?=$(ROOT_DIR)/.runenv

#+ Devenv prerequisite list (use += to add some targets)
DEVENV_PREREQ?=

#+ Runenv prerequisite list (use += to add some targets)
RUNENV_PREREQ?=

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
before_all::

.PHONY: clean before_clean
clean:: before_clean ## Clean build and temporary files
	rm -Rf .refresh_makefiles.tmp "$(ROOT_TMP)" "$(ROOT_TOOLS)"
	rm -f "$(DEVENV_FILE)" "$(RUNENV_FILE)"
before_clean::

.PHONY: refresh before_refresh
refresh:: before_refresh refresh_common_makefiles ## Refresh all things
before_refresh::

.PHONY: refresh_common_makefiles
refresh_common_makefiles: ## Refresh common makefiles from repository
	rm -Rf .refresh_makefiles.tmp && mkdir -p .refresh_makefiles.tmp
	cd .refresh_makefiles.tmp && $(_GIT_CLONE_DEPTH_1) $(COMMON_MAKEFILES_GIT_URL) && $(_GIT_CHECKOUT_BRANCH) && rm -Rf ../.common_makefiles && mv common_makefiles/dist ../.common_makefiles
	rm -Rf .refresh_makefiles.tmp

.PHONY: help
help::
	@mkdir -p "$(ROOT_TMP)"
	@# See https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
	@cat $(MAKEFILE_LIST) >"$(ROOT_DIR)/.tmp/help.txt"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' "$(ROOT_DIR)/.tmp/help.txt" | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@rm -f "$(ROOT_DIR)/.tmp/help.txt"

.PHONY: devenv before_devenv _devenv remove_devenv
devenv: $(DEVENV_FILE) ## Prepare dev environment
$(DEVENV_FILE): $$(DEVENV_PREREQ)
	if test -f "$(RUNENV_FILE)"; then $(MAKE) remove_runenv; fi
	$(MAKE) _devenv
	touch "$@"
_devenv:: before_devenv
before_devenv::
remove_devenv::
	rm -f $(DEVENV_FILE)

.PHONY: runenv before_runenv _runenv remove_runenv
runenv: $(RUNENV_FILE) ## Prepare run environment
$(RUNENV_FILE): $$(RUNENV_PREREQ)
	if test -f "$(DEVENV_FILE)"; then $(MAKE) remove_devenv; fi
	$(MAKE) _runenv
	touch "$@"
_runenv:: before_runenv
before_runenv::
remove_runenv::
	rm -f $(RUNENV_FILE)

.PHONY: lint before_lint
lint:: before_lint ## Lint the code

#+ target executed before lint target
before_lint:: devenv

.PHONY: reformat before_reformat
reformat:: before_reformat ## Reformat sources and tests
before_reformat:: devenv

.PHONY: check before_check tests
check:: before_check
before_check:: devenv
tests: check ## Simple alias for "check" target

.PHONY: coverage_console before_coverage_console
coverage_console:: before_coverage_console ## Execute unit-tests and show coverage in console
before_coverage_console:: devenv

.PHONY: coverage_html before_coverage_html
coverage_html:: before_coverage_html ## Execute unit-tests and show coverage in html
before_coverage_html:: devenv

.PHONY: coverage_sonar before_coverage_sonar coverage_xml
coverage_sonar:: before_coverage_sonar ## Execute unit-tests and build coverage file for sonarqube
before_coverage_sonar:: devenv

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