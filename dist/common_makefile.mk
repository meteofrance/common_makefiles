##### ROOT COMMON MAKEFILE #####
#
# See https://github.com/meteofrance/common_makefiles
#
# Implement mainly only help and refresh_common_makefiles targets

.PHONY: clean help all default _make_help_banner refresh_common_makefiles refresh
.DEFAULT_GOAL: default

SHELL=/bin/bash
GIT=git
COMMON_MAKEFILES_GIT_URL=http://github.com/metwork-framework/common_makefiles.git
GIT_CLONE_DEPTH_1=$(GIT) clone --depth 1
ROOT_DIR:=$(shell dirname $(realpath $(lastword $(MAKEFILE_LIST))))
COMMON_MAKEFILES_SUBDIR=.common_makefiles


default:: _make_help_banner all

_make_help_banner:
	@echo "Executing default all target (use 'make help' to show other targets/options)"

all::

clean:: ## Clean build and temporary files
	@rm -Rf .help.txt .refresh_makefiles.tmp

refresh:: refresh_common_makefiles ## Refresh all things 

refresh_common_makefiles: ## Refresh common makefiles from repository
	rm -Rf .refresh_common_makefiles.tmp && mkdir -p .refresh_common_makefiles.tmp
	cd .refresh_common_makefiles.tmp && $(GIT_CLONE_DEPTH_1) $(COMMON_MAKEFILES_GIT_URL) && rm -Rf ../$(COMMON_MAKEFILES_SUBDIR) && mv common_makefiles/dist ../$(COMMON_MAKEFILES_SUBDIR)
	rm -Rf .refresh_common_makefiles.tmp

help::
	@# See https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
	@cat $(MAKEFILE_LIST) >.help.txt
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' .help.txt | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
	@rm -f .help.txt
