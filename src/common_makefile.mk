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

{% for target in ["devenv", "runenv"] %}
.PHONY: {{target}} before_{{target}} remove_{{target}} _after_remove_{{target}} before_remove_{{target}} custom_remove_{{target}} _remove_{{target}}
{{target}}: $(EXTRA_PREREQ) $({{target|upper}}_FILE) ## Prepare {{target}} environment
$({{target|upper}}_FILE): $$(_{{target|upper}}_PREREQ) $$({{target|upper}}_PREREQ)
	@$(HEADER1) "{{target}} is ready"
	@touch "$@"
before_{{target}}::
	@$(HEADER1) "Building {{target}}"
remove_{{target}}: before_remove_{{target}} _remove_{{target}} custom_remove_{{target}} _after_remove_{{target}}
_remove_{{target}}::
before_remove_{{target}}::
	@$(HEADER2) "Removing {{target}}"
custom_remove_{{target}}::
	@$(HEADER2) "Calling custom_remove_{{target}}"
_after_remove_{{target}}:
	@rm -f $({{target|upper}}_FILE)
	@$(HEADER2) "{{target|capitalize}} removed"
{% endfor %}

{% for target in ["lint", "reformat", "clean", "distclean", "check", "coverage"] %}
.PHONY: {{target}} before_{{target}} custom_{{target}} _after_{{target}} _{{target}}
{{target}}: $(EXTRA_PREREQ) {% if target == "distclean" %}clean {% endif %}before_{{target}} _{{target}} custom_{{target}} _after_{{target}} ## {{target|capitalize}} the code
#+ target executed before {{target}} target
before_{{target}}:: {% if target not in ["clean", "distclean"] %}devenv{% endif %}
	@$(HEADER1) "{{target|capitalize}}ing" 2>/dev/null || true
	@$(HEADER2) "Calling before_{{target}} target" 2>/dev/null || true
_{{target}}::
	@$(HEADER2) "Common {{target}}ing" 2>/dev/null || true
	{% if target == "clean" %}
	rm -Rf "$(ROOT_TMP)"
	{% elif target == "distclean" %}
	rm -Rf "$(ROOT_TOOLS)"
	{% endif %}
#+ custom {{target}}ing target
custom_{{target}}::
	@$(HEADER2) "Calling custom_{{target}} target" 2>/dev/null || true
_after_{{target}}:
	@$(HEADER1) "{{target|capitalize}}ing OK" 2>/dev/null || true
	{% if target == "clean" %}
	@echo "Note: you can clean a little more (tools, venv...) with 'make distclean'"
	{% endif %}
{% endfor %}

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
