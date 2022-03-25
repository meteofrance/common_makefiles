.PHONY: clean help all default _make_help_banner refresh_common_makefiles refresh
.DEFAULT_GOAL: default
SHELL=/bin/bash

# Binary to use for git
GIT=git

# Binary to use for wget
WGET=wget

# Common makefiles git url (for refresh_makefiles target)
COMMON_MAKEFILES_GIT_URL=http://github.com/meteofrance/common_makefiles.git

_GIT_CLONE_DEPTH_1=$(GIT) clone --depth 1
ROOT_DIR:=$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))
ROOT_TMP=$(ROOT_DIR)/.tmp
ROOT_TOOLS=$(ROOT_DIR)/.tools


default:: _make_help_banner all

_make_help_banner:
	@echo "Executing default all target (use 'make help' to show other targets/options)"

all::

clean:: ## Clean build and temporary files
	@rm -Rf .refresh_makefiles.tmp "$(ROOT_TMP)" "$(ROOT_TOOLS)"

refresh:: ## Refresh all things
	$(MAKE) refresh_common_makefiles

refresh_common_makefiles: ## Refresh common makefiles from repository
	rm -Rf .refresh_makefiles.tmp && mkdir -p .refresh_makefiles.tmp
	cd .refresh_makefiles.tmp && $(_GIT_CLONE_DEPTH_1) $(COMMON_MAKEFILES_GIT_URL) && rm -Rf ../.common_makefiles && mv common_makefiles/dist ../.common_makefiles
	rm -Rf .refresh_makefiles.tmp

help::
	@mkdir -p "$(ROOT_TMP)"
	@# See https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
	@cat $(MAKEFILE_LIST) >"$(ROOT_DIR)/.tmp/help.txt"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' "$(ROOT_DIR)/.tmp/help.txt" | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@rm -f "$(ROOT_DIR)/.tmp/help.txt"

lint::  ## Lint the code
reformat:: ## Reformat sources and tests
tests:: ## Execute unit-tests
coverage_console:: ## Execute unit-tests and show coverage in console
coverage_html:: ## Execute unit-tests and show coverage in html
coverage_sonar:: ## Execute unit-tests and make coverage output file for sonarqube

_debug:: ## Dump common_makefiles configuration
	@echo "COMMON_MAKEFILES_GIT_URL=$(COMMON_MAKEFILES_GIT_URL)"
	@echo "GIT=$(GIT)"
	@echo "WGET=$(WGET)"
	@echo "MAKEFILE_LIST=$(MAKEFILE_LIST)"
	@echo "ROOT_DIR=$(ROOT_DIR)"
	@echo "ROOT_TMP=$(ROOT_TMP)"
	@echo "ROOL_TOOLS=$(ROOT_TOOLS)"
