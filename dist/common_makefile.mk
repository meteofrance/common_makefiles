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

_GIT_CLONE=$(GIT) clone
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

## Devenv flag file (if it exists, the dev env is set up)
DEVENV_FILE?=$(ROOT_TOOLS)/devenv

## Runenv flag file (if it exists, the run env is set up)
RUNENV_FILE?=$(ROOT_TOOLS)/runenv

#+ Display help with all target
#+ 1 => yes
#+ 0 => no
SHOW_HELP_WITH_ALL_TARGET=1

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
    _RUNENV_PREREQ+=remove_devenv
endif
ifeq ("$(wildcard $(RUNENV_FILE))","")
    _RUNENV_PREREQ+=before_runenv
endif

.PHONY: default
default:: _make_help_banner all

.PHONY: _make_help_banner
_make_help_banner:
	@if test "$(SHOW_HELP_WITH_ALL_TARGET)" = "1"; then echo "Executing default all target (use 'make help' to show other targets/options)"; fi

.PHONY: all before_all
_ALL_PREREQ=$(RUNENV_FILE)
EXTRA_PREREQ=$(ROOT_TOOLS)/common_makefiles_extra/common.sh
ifneq ("$(wildcard $(DEVENV_FILE))","")
    _ALL_PREREQ=$(DEVENV_FILE)
endif
all:: before_all $(_ALL_PREREQ)
before_all:: $(EXTRA_PREREQ)

_EXTRA_PREREQ=$(ROOT_COMMON)/extra.tar.gz
$(ROOT_TOOLS)/common_makefiles_extra/common.sh: $(_EXTRA_PREREQ)
	@rm -Rf "$(ROOT_TOOLS)/common_makefiles_extra"
	@mkdir -p "$(ROOT_TOOLS)"
	@if test -f "$<"; then mkdir -p "$(ROOT_TOOLS)/common_makefiles_extra" && cd "$(ROOT_TOOLS)/common_makefiles_extra" && zcat "$<" |tar xf - && cd extra && mv * .. && cd .. && rm -Rf extra; touch "$@"; fi

.PHONY: help
help::
	@mkdir -p "$(ROOT_TMP)"
	@# See https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
	@cat $(MAKEFILE_LIST) >"$(ROOT_DIR)/.tmp/help.txt"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' "$(ROOT_DIR)/.tmp/help.txt" | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@rm -f "$(ROOT_DIR)/.tmp/help.txt"


.PHONY: devenv before_devenv remove_devenv _after_remove_devenv before_remove_devenv custom_remove_devenv _remove_devenv
devenv: $(EXTRA_PREREQ) $(DEVENV_FILE) ## Prepare devenv environment
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
runenv: $(EXTRA_PREREQ) $(RUNENV_FILE) ## Prepare runenv environment
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
#+ target executed before lint target
before_lint:: devenv
	@$(HEADER1) "Linting" 2>/dev/null || true
	@$(HEADER2) "Calling before_lint target" 2>/dev/null || true
_lint::
	@$(HEADER2) "Common linting" 2>/dev/null || true
	
#+ custom linting target
custom_lint::
	@$(HEADER2) "Calling custom_lint target" 2>/dev/null || true
_after_lint:
	@$(HEADER1) "Linting OK" 2>/dev/null || true
	

.PHONY: reformat before_reformat custom_reformat _after_reformat _reformat
reformat: $(EXTRA_PREREQ) before_reformat _reformat custom_reformat _after_reformat ## Reformat the code
#+ target executed before reformat target
before_reformat:: devenv
	@$(HEADER1) "Reformating" 2>/dev/null || true
	@$(HEADER2) "Calling before_reformat target" 2>/dev/null || true
_reformat::
	@$(HEADER2) "Common reformating" 2>/dev/null || true
	
#+ custom reformating target
custom_reformat::
	@$(HEADER2) "Calling custom_reformat target" 2>/dev/null || true
_after_reformat:
	@$(HEADER1) "Reformating OK" 2>/dev/null || true
	

.PHONY: clean before_clean custom_clean _after_clean _clean
clean: $(EXTRA_PREREQ) before_clean _clean custom_clean _after_clean ## Clean the code
#+ target executed before clean target
before_clean:: 
	@$(HEADER1) "Cleaning" 2>/dev/null || true
	@$(HEADER2) "Calling before_clean target" 2>/dev/null || true
_clean::
	@$(HEADER2) "Common cleaning" 2>/dev/null || true
	
	rm -Rf "$(ROOT_TMP)"
	
#+ custom cleaning target
custom_clean::
	@$(HEADER2) "Calling custom_clean target" 2>/dev/null || true
_after_clean:
	@$(HEADER1) "Cleaning OK" 2>/dev/null || true
	
	@echo "Note: you can clean a little more (tools, venv...) with 'make distclean'"
	

.PHONY: distclean before_distclean custom_distclean _after_distclean _distclean
distclean: $(EXTRA_PREREQ) clean before_distclean _distclean custom_distclean _after_distclean ## Distclean the code
#+ target executed before distclean target
before_distclean:: 
	@$(HEADER1) "Distcleaning" 2>/dev/null || true
	@$(HEADER2) "Calling before_distclean target" 2>/dev/null || true
_distclean::
	@$(HEADER2) "Common distcleaning" 2>/dev/null || true
	
	rm -Rf "$(ROOT_TOOLS)"
	
#+ custom distcleaning target
custom_distclean::
	@$(HEADER2) "Calling custom_distclean target" 2>/dev/null || true
_after_distclean:
	@$(HEADER1) "Distcleaning OK" 2>/dev/null || true
	

.PHONY: check before_check custom_check _after_check _check
check: $(EXTRA_PREREQ) before_check _check custom_check _after_check ## Check the code
#+ target executed before check target
before_check:: devenv
	@$(HEADER1) "Checking" 2>/dev/null || true
	@$(HEADER2) "Calling before_check target" 2>/dev/null || true
_check::
	@$(HEADER2) "Common checking" 2>/dev/null || true
	
#+ custom checking target
custom_check::
	@$(HEADER2) "Calling custom_check target" 2>/dev/null || true
_after_check:
	@$(HEADER1) "Checking OK" 2>/dev/null || true
	

.PHONY: coverage before_coverage custom_coverage _after_coverage _coverage
coverage: $(EXTRA_PREREQ) before_coverage _coverage custom_coverage _after_coverage ## Coverage the code
#+ target executed before coverage target
before_coverage:: devenv
	@$(HEADER1) "Coverageing" 2>/dev/null || true
	@$(HEADER2) "Calling before_coverage target" 2>/dev/null || true
_coverage::
	@$(HEADER2) "Common coverageing" 2>/dev/null || true
	
#+ custom coverageing target
custom_coverage::
	@$(HEADER2) "Calling custom_coverage target" 2>/dev/null || true
_after_coverage:
	@$(HEADER1) "Coverageing OK" 2>/dev/null || true
	


.PHONY: refresh_common_makefiles
refresh_common_makefiles: ## Refresh common makefiles from repository
	@$(HEADER2) "Refreshing common makefiles" || true
	rm -Rf .refresh_makefiles.tmp && mkdir -p .refresh_makefiles.tmp
	cd .refresh_makefiles.tmp && $(_GIT_CLONE) $(COMMON_MAKEFILES_GIT_URL) && $(_GIT_CHECKOUT_BRANCH) && rm -Rf ../.common_makefiles && mv common_makefiles/dist ../.common_makefiles
	rm -Rf .refresh_makefiles.tmp
	@$(HEADER2) "common makefiles refreshed" || true

.PHONY: tests
## simple alias of check target
tests: check

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
	@echo "_DEVENV_PREREQ=$(_DEVENV_PREREQ)"
	@echo "_RUNENV_PREREQ=$(_RUNENV_PREREQ)"
	@echo "_ALL_PREREQ=$(_ALL_PREREQ)"
	@echo "EXTRA_PREREQ=$(EXTRA_PREREQ)"
	@echo "RUNENV_FILE=$(RUNENV_FILE)"
	@echo "DEVENV_FILE=$(DEVENV_FILE)"
