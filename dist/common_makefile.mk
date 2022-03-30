# makefile configuration
# see https://www.gnu.org/software/make/manual/html_node/Special-Targets.html
.DELETE_ON_ERROR:
.SECONDEXPANSION:
.DEFAULT_GOAL: default
SHELL=/bin/bash

# define standard colors
ifneq (,$(findstring xterm,${TERM}))
	BOLD        := $(shell tput -Txterm bold)
	RED         := $(shell tput -Txterm setaf 1)
	BLUE         := $(shell tput -Txterm setaf 6)
	RESET       := $(shell tput -Txterm sgr0)
else
	BOLD        := ""
	RED         := ""
	BLUE        := ""
	RESET       := ""
endif

define header1
    @CAP=$$(echo $1 |tr '/a-z/' '/A-Z/') ; printf "$(BOLD)***** $${CAP} *****$(RESET)\n"
endef
define header2
	@printf "$(BLUE)*** $1 ***$(RESET)\n"
endef

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
before_all::

.PHONY: help
help::
	@mkdir -p "$(ROOT_TMP)"
	@# See https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
	@cat $(MAKEFILE_LIST) >"$(ROOT_DIR)/.tmp/help.txt"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' "$(ROOT_DIR)/.tmp/help.txt" | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@rm -f "$(ROOT_DIR)/.tmp/help.txt"

.PHONY: devenv before_devenv remove_devenv _after_remove_devenv before_remove_devenv custom_remove_devenv _remove_devenv
devenv: $(DEVENV_FILE) ## Prepare dev environment
$(DEVENV_FILE): $$(_DEVENV_PREREQ) $$(DEVENV_PREREQ)
	$(call header1,devenv is ready)
	@touch "$@"
before_devenv::
	$(call header1,Building devenv)
remove_devenv: before_remove_devenv _remove_devenv custom_remove_devenv _after_remove_devenv
_remove_devenv::
before_remove_devenv::
	$(call header1,Removing devenv)
custom_remove_devenv::
	$(call header2,Calling custom_remove_devenv)
_after_remove_devenv:
	@rm -f $(DEVENV_FILE)
	$(call header1,Devenv removed)

.PHONY: runenv before_runenv remove_runenv _after_remove_runenv before_remove_runenv custom_remove_runenv _remove_runenv
runenv: $(RUNENV_FILE) ## Prepare run environment
$(RUNENV_FILE): $$(_RUNENV_PREREQ) $$(RUNENV_PREREQ)
	$(call header1,runenv is ready)
	@touch "$@"
before_runenv::
	$(call header1,Building runenv)
remove_runenv: before_remove_runenv _remove_runenv custom_remove_runenv _after_remove_runenv
_remove_runenv::
before_remove_runenv::
	$(call header1,Removing runenv)
custom_remove_runenv::
	$(call header2,Calling custom_remove_runenv)
_after_remove_runenv:
	@rm -f $(RUNENV_FILE)
	$(call header1,Runenv removed)

.PHONY: lint before_lint custom_lint _after_lint _lint
lint: before_lint _lint custom_lint _after_lint ## Lint the code
#+ target executed before linting
before_lint:: devenv
	$(call header1,Linting)
	$(call header2,Calling before_lint target)
_lint::
	$(call header2,Common linting)
#+ custom linting target
custom_lint::
	$(call header2,Calling custom_lint target)
_after_lint:
	$(call header1,Linting OK)

.PHONY: reformat before_reformat custom_reformat _after_reformat _reformat
reformat: before_reformat _reformat custom_reformat _after_reformat ## Reformat sources and tests
#+ target executed before reformating
before_reformat:: devenv
	$(call header1,Reformating)
	$(call header2,Calling before_reformat target)
_reformat::
	$(call header2,Common reformating)
#+ custom reformating target
custom_reformat::
	$(call header2,Calling custom_lint target)
_after_reformat:
	$(call header1,Reformating OK)

.PHONY: clean before_clean
clean: before_clean _clean custom_clean _after_clean ## Clean build and temporary files
#+ target executed before cleaning
before_clean::
	$(call header1,Cleaning)
	$(call header2,Calling before_clean target)
_clean:: remove_devenv remove_runenv
	$(call header2,Common cleaning)
	rm -Rf .refresh_makefiles.tmp "$(ROOT_TMP)" "$(ROOT_TOOLS)"
	rm -f "$(DEVENV_FILE)" "$(RUNENV_FILE)"
#+ custom reformating target
custom_clean::
	$(call header2,Calling custom_clean target)
_after_clean:
	$(call header1,Cleaning OK)

.PHONY: check before_check custom_check _after_check _check tests
check: before_check _check custom_check _after_check ## Execute tests
#+ target executed before tests
before_check:: devenv
	$(call header1,Executing tests)
	$(call header2,Calling before_check target)
_check::
	$(call header2,Common checks)
#+ custom check target
custom_check::
	$(call header2,Calling custom_check target)
_after_check:
	$(call header1,Checks OK)
## Simple alias for "check" target
tests: check

.PHONY: refresh before_refresh custom_refresh _after_refresh _refresh refresh_common_makefiles
refresh: before_refresh _refresh custom_refresh _after_refresh ## Refresh all things
before_refresh::
	$(call header1,Refreshing)
	$(call header2,Calling before_refresh target)
_refresh::
	$(call header2,Common refreshing)
_refresh:: refresh_common_makefiles
custom_refresh::
	$(call header2,Calling custom_refresh target)
_after_refresh:
	$(call header1,Refresh OK)
refresh_common_makefiles: ## Refresh common makefiles from repository
	$(call header2,Refreshing common makefiles)
	rm -Rf .refresh_makefiles.tmp && mkdir -p .refresh_makefiles.tmp
	cd .refresh_makefiles.tmp && $(_GIT_CLONE_DEPTH_1) $(COMMON_MAKEFILES_GIT_URL) && $(_GIT_CHECKOUT_BRANCH) && rm -Rf ../.common_makefiles && mv common_makefiles/dist ../.common_makefiles
	rm -Rf .refresh_makefiles.tmp
	$(call header2,common makefiles refreshed)

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