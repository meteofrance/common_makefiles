##########################
##### configuration ######
##########################

#* python interpreter configuration:
#* AUTO_3_8    => auto-download python 3.8
#* AUTO_3_9    => auto-download python 3.9
#* AUTO_3_10   => auto-download python 3.10
#* (path)      => use this binary
PYTHON?=AUTO_3_9

#+ python 3.8 download url
PYTHON_3_8_URL?=https://github.com/indygreg/python-build-standalone/releases/download/20220318/cpython-3.8.13+20220318-x86_64-unknown-linux-gnu-install_only.tar.gz

#+ python 3.9 download url
PYTHON_3_9_URL?=https://github.com/indygreg/python-build-standalone/releases/download/20220318/cpython-3.9.11+20220318-x86_64-unknown-linux-gnu-install_only.tar.gz

#+ python 3.10 download url
PYTHON_3_10_URL?=https://github.com/indygreg/python-build-standalone/releases/download/20220318/cpython-3.10.3+20220318-x86_64-unknown-linux-gnu-install_only.tar.gz

#+ black binary to use
#+ (binary name or path) => use this binary name/path (if exists)
#+ (empty)               => disable usage
BLACK?=black

#+ black reformat options
BLACK_REFORMAT_OPTIONS?=--line-length=$(_MAX_LINE_LENGTH_MINUS_1)

#+ black lint options
BLACK_LINT_OPTIONS?=$(BLACK_REFORMAT_OPTIONS) --quiet --check

#+ isort binary to use
#+ (binary name or path) => use this binary name/path (if exists)
#+ (empty)               => disable usage
ISORT?=isort

#+ isort reformat options
ISORT_REFORMAT_OPTIONS?=--profile=black --lines-after-imports=2 --virtual-env=$(VENV_DIR)

#+ isort lint options
ISORT_LINT_OPTIONS?=$(ISORT_REFORMAT_OPTIONS) --check-only

#+ max line length (for linting/reformating)
MAX_LINE_LENGTH?=89

_MAX_LINE_LENGTH_MINUS_1=$(shell echo $$(($(MAX_LINE_LENGTH) - 1)))

#+ flake8 binary to use
#+ (binary name or path) => use this binary name/path (if exists)
#+ (empty)               => disable usage
FLAKE8?=flake8

#+ flake8 lint options
FLAKE8_LINT_OPTIONS?=--ignore=W503,E501 --max-line-length=$(MAX_LINE_LENGTH)

#+ pylint binary to use
#+ (binary name or path) => use this binary name/path (if exists)
#+ (empty)               => disable usage
PYLINT?=pylint

#+ pylint lint options
PYLINT_LINT_OPTIONS?=--errors-only --extension-pkg-whitelist=pydantic,_ldap

#+ mypy binary to use
#+ (binary name or path) => use this binary name/path (if exists)
#+ (empty)               => disable usage
MYPY?=mypy

#+ mypy lint options
MYPY_LINT_OPTIONS?=--ignore-missing-imports

#+ bandit binary to use
#+ (binary name or path) => use this binary name/path (if exists)
#+ (empty)               => disable usage
BANDIT?=bandit

#+ bandit lint options
BANDIT_LINT_OPTIONS?=-ll -r

#+ lint-imports binary to use
#+ (binary name or path) => use this binary name/path (if exists)
#+ (empty)               => disable usage
LINTIMPORTS?=lint-imports

#+ lint-imports configuration file
LINTIMPORTS_CONF_FILE?=$(ROOT_DIR)/.importlinter

#+ pytest binary to use
#+ (binary name or path) => use this binary name/path (if exists)
#+ (empty)               => disable usage
PYTEST=pytest

#+ pytest options (for unit testing)
PYTEST_CHECK_OPTIONS?=

#+ pytest options (for coverage)
PYTEST_COVERAGE_OPTIONS?=--cov=$(APP_DIRS) --cov-report=html --cov-report=xml --cov-report=term

#+ twine binary to use
#+ (binary name or path) => use this binary name/path (if exists)
#+ (empty)               => disable usage
TWINE=twine

#+ twine repository
TWINE_REPOSITORY?=

#+ twine username
TWINE_USERNAME?=

#+ twine password
TWINE_PASSWORD?=

#+ twine extra options
TWINE_UPLOAD_EXTRA_OPTIONS?=

#+ safety binary to use
#+ (binary name or path) => use this binary name/path (if exists)
#+ (empty)               => disable usage
SAFETY?=safety

#+ if set to 1, run also safety on dev dependencies
#+ if set to 0 (default), safety will be run only on runtime dependencies
SAFETY_ON_DEV_DEPS?=0

#+ safety check options
SAFETY_CHECK_OPTIONS?=

#+ pip common options
PIP_COMMON_OPTIONS?=--disable-pip-version-check

#+ pip index url
PIP_INDEX_URL?=

#+ pip extra index url
PIP_EXTRA_INDEX_URL?=

#+ pip install extra options
PIP_INSTALL_OPTIONS?=

#+ pip trusted hosts
#+ (override it with += to add some trusted hosts)
PIP_TRUSTED_HOSTS+=pypi.org files.pythonhosted.org

## virtualenv directory
VENV_DIR=$(ROOT_TOOLS)/venv
TMP_VENV_DIR=$(ROOT_TMP)/venv

#+ add a symlink of this name in the project root
#+ (targetting the VENV_DIR)
#+ (if empty => no symlink)
VENV_SYMLINK=venv

#+ requirements dir
REQS_DIR?=$(ROOT_DIR)

#+ remove "dist" directory during clean
REMOVE_DIST?=1

#+ remove "build" directory during clean
REMOVE_BUILD?=1

#+ python application dirs (space separated)
APP_DIRS?=

#+ tests application dirs (space separated)
TEST_DIRS?=

#+ extra python files to lint/reformat
#+ (if they are outside of APP_DIRS/TEST_DIRS)
#+ (space separated paths)
EXTRA_PYTHON_FILES?=
_APP_AND_TEST_DIRS=$(APP_DIRS) $(TEST_DIRS) $(wildcard setup.py) $(EXTRA_PYTHON_FILES)

###############################
##### python auto-install #####
###############################
_PYTHON_URL=
ifeq ($(PYTHON),AUTO_3_8)
	RUNENV_PREREQ+=$(ROOT_TOOLS)/python/bin/python3.8
	DEVENV_PREREQ+=$(ROOT_TOOLS)/python/bin/python3.8
	_PYTHON_BIN=$(ROOT_TOOLS)/python/bin/python3.8
	_PYTHON_URL=$(PYTHON_3_8_URL)
else ifeq ($(PYTHON),AUTO_3_9)
	RUNENV_PREREQ+=$(ROOT_TOOLS)/python/bin/python3.9
	DEVENV_PREREQ+=$(ROOT_TOOLS)/python/bin/python3.9
	_PYTHON_BIN=$(ROOT_TOOLS)/python/bin/python3.9
	_PYTHON_URL=$(PYTHON_3_9_URL)
else ifeq ($(PYTHON),AUTO_3_10)
	RUNENV_PREREQ+=$(ROOT_TOOLS)/python/bin/python3.10
	DEVENV_PREREQ+=$(ROOT_TOOLS)/python/bin/python3.10
	_PYTHON_BIN=$(ROOT_TOOLS)/python/bin/python3.10
	_PYTHON_URL=$(PYTHON_3_10_URL)
else
	_PYTHON_BIN=$(shell which $(PYTHON))
endif

define install_python
	@$(HEADER2) "Installing python..."
	mkdir -p "$(ROOT_TOOLS)"
	mkdir -p "$(ROOT_TMP)"
	rm -Rf "$(ROOT_TOOLS)/python"
	$(WGET) -O "$(ROOT_TMP)/python.tar.gz" "$(_PYTHON_URL)"
	cd "$(ROOT_TOOLS)" && zcat "$(ROOT_TMP)/python.tar.gz" |tar xf -
	rm -f "$(ROOT_TMP)/python.tar.gz"
	@$(HEADER2) "python installed"
endef

$(ROOT_TOOLS)/python/bin/python3.8:
	@rm -Rf $(ROOT_TOOLS)/python
	$(call install_python)

$(ROOT_TOOLS)/python/bin/python3.9:
	@rm -Rf $(ROOT_TOOLS)/python
	$(call install_python)

$(ROOT_TOOLS)/python/bin/python3.10:
	@rm -Rf $(ROOT_TOOLS)/python
	$(call install_python)


########################################
##### venv/requirements management #####
########################################
DEVENV_PREREQ+=$(VENV_DIR)/devenv
RUNENV_PREREQ+=$(VENV_DIR)/runenv
_PIP=pip3
_MAKE_VIRTUALENV=$(_PYTHON_BIN) -m venv
ENTER_TEMP_VENV=. $(TMP_VENV_DIR)/bin/activate
## "enter virtualenv" variable
## you can use it in your Makefile scripts, for example:
## $(ENTER_VENV) && pip freeze
ENTER_VENV=. $(VENV_DIR)/bin/activate
_PIP_INDEX_URL_OPT=$(if $(PIP_INDEX_URL),--index-url $(PIP_INDEX_URL),)
_PIP_EXTRA_INDEX_URL_OPT=$(if $(PIP_EXTRA_INDEX_URL),--extra-index-url $(PIP_EXTRA_INDEX_URL),)
_PIP_TRUSTED_OPT=$(addprefix --trusted-host ,$(PIP_TRUSTED_HOSTS))
_PIP_INSTALL=$(_PIP) $(PIP_COMMON_OPTIONS) install $(_PIP_INDEX_URL_OPT) $(_PIP_EXTRA_INDEX_URL_OPT) $(_PIP_TRUSTED_OPT) $(PIP_INSTALL_OPTIONS)
_PIP_FREEZE=$(_PIP) $(PIP_COMMON_OPTIONS) freeze --all --exclude setuptools --exclude distribute --exclude pip
_PREREQ=
_PREDEVREQ=
_FORCEDREQ=
ifneq ($(wildcard $(REQS_DIR)/forced-requirements.txt),)
	_FORCEDREQ+=$(REQS_DIR)/forced-requirements.txt
endif
ifneq ($(wildcard $(REQS_DIR)/prerequirements-notfreezed.txt),)
	_PREREQ+=$(REQS_DIR)/prerequirements.txt
endif
ifneq ($(wildcard $(REQS_DIR)/predevrequirements-notfreezed.txt),)
	_PREDEVREQ+=$(REQS_DIR)/predevrequirements.txt
endif
DEVENV_PREREQ+=$(REQS_DIR)/devrequirements.txt
RUNENV_PREREQ+=$(REQS_DIR)/requirements.txt

.PHONY: devvenv

## simple alias of devenv target
devvenv: devenv


$(REQS_DIR)/prerequirements.txt: $(REQS_DIR)/prerequirements-notfreezed.txt  $(_FORCEDREQ)
	@$(HEADER2) "Creating $@ from $^"
	rm -Rf "$(TMP_VENV_DIR)"
	$(_MAKE_VIRTUALENV) "$(TMP_VENV_DIR)"
	
	$(ENTER_TEMP_VENV) && $(_PIP_INSTALL) -r "$<"
	cat "$(_EXTRA)/prerequirements.txt" >"$@"
	$(ENTER_TEMP_VENV) && $(_PIP_FREEZE) |$(_PYTHON_BIN) "$(_EXTRA)/python_forced_requirements_filter.py" "$(REQS_DIR)/forced-requirements.txt" >>"$@"
	rm -Rf "$(TMP_VENV_DIR)"
	@$(HEADER2) "$@ created"

$(REQS_DIR)/predevrequirements.txt: $(REQS_DIR)/predevrequirements-notfreezed.txt  $(_FORCEDREQ)
	@$(HEADER2) "Creating $@ from $^"
	rm -Rf "$(TMP_VENV_DIR)"
	$(_MAKE_VIRTUALENV) "$(TMP_VENV_DIR)"
	
	$(ENTER_TEMP_VENV) && $(_PIP_INSTALL) -r "$<"
	cat "$(_EXTRA)/predevrequirements.txt" >"$@"
	$(ENTER_TEMP_VENV) && $(_PIP_FREEZE) |$(_PYTHON_BIN) "$(_EXTRA)/python_forced_requirements_filter.py" "$(REQS_DIR)/forced-requirements.txt" >>"$@"
	rm -Rf "$(TMP_VENV_DIR)"
	@$(HEADER2) "$@ created"

$(REQS_DIR)/devrequirements.txt: $(REQS_DIR)/devrequirements-notfreezed.txt $(REQS_DIR)/requirements.txt $(_PREDEVREQ) $(_FORCEDREQ)
	@$(HEADER2) "Creating $@ from $^"
	rm -Rf "$(TMP_VENV_DIR)"
	$(_MAKE_VIRTUALENV) "$(TMP_VENV_DIR)"
	
	if test -f "$(REQS_DIR)/predevrequirements.txt"; then $(ENTER_TEMP_VENV) && $(_PIP_INSTALL) -r "$(REQS_DIR)/predevrequirements.txt"; fi
	
	$(ENTER_TEMP_VENV) && $(_PIP_INSTALL) -r "$<"
	cat "$(_EXTRA)/devrequirements.txt" >"$@"
	$(ENTER_TEMP_VENV) && $(_PIP_FREEZE) |$(_PYTHON_BIN) "$(_EXTRA)/python_forced_requirements_filter.py" "$(REQS_DIR)/forced-requirements.txt" >>"$@"
	rm -Rf "$(TMP_VENV_DIR)"
	@$(HEADER2) "$@ created"

$(REQS_DIR)/requirements.txt: $(REQS_DIR)/requirements-notfreezed.txt $(_PREREQ) $(_FORCEDREQ)
	@$(HEADER2) "Creating $@ from $^"
	rm -Rf "$(TMP_VENV_DIR)"
	$(_MAKE_VIRTUALENV) "$(TMP_VENV_DIR)"
	
	if test -f "$(REQS_DIR)/prerequirements.txt"; then $(ENTER_TEMP_VENV) && $(_PIP_INSTALL) -r "$(REQS_DIR)/prerequirements.txt"; fi
	
	$(ENTER_TEMP_VENV) && $(_PIP_INSTALL) -r "$<"
	cat "$(_EXTRA)/requirements.txt" >"$@"
	$(ENTER_TEMP_VENV) && $(_PIP_FREEZE) |$(_PYTHON_BIN) "$(_EXTRA)/python_forced_requirements_filter.py" "$(REQS_DIR)/forced-requirements.txt" >>"$@"
	rm -Rf "$(TMP_VENV_DIR)"
	@$(HEADER2) "$@ created"


$(REQS_DIR)/devrequirements-notfreezed.txt:
	cp -f "$(_EXTRA)/devrequirements-notfreezed.txt" "$@"

$(REQS_DIR)/requirements-notfreezed.txt:
	cp -f "$(_EXTRA)/requirements-notfreezed.txt" "$@"

.PHONY: refresh_venv _rm_requirements refresh
refresh_venv: remove_devenv remove_runenv _rm_requirements devenv ## Update all *requirements.txt files from *requirements-freezed.txt and pip repositories
_rm_requirements:
	rm -f $(REQS_DIR)/predevrequirements.txt
	rm -f $(REQS_DIR)/prerequirements.txt
	rm -f $(REQS_DIR)/devrequirements.txt
	rm -f $(REQS_DIR)/requirements.txt
## Deprecated alias of refresh_venv
refresh: refresh_venv



$(VENV_DIR)/devenv: $(REQS_DIR)/devrequirements.txt
	@$(HEADER2) "Creating $(VENV_DIR) (devenv) from $^"
	rm -Rf "$(VENV_DIR)"
	$(_MAKE_VIRTUALENV) "$(VENV_DIR)"
	if test -f "$(REQS_DIR)/predevrequirements.txt"; then $(ENTER_VENV) && $(_PIP_INSTALL) -r "$(REQS_DIR)/predevrequirements.txt"; fi
	$(ENTER_VENV) && $(_PIP_INSTALL) -r "$<"
	
	if test -f setup.py; then $(ENTER_VENV) && $(_PIP_INSTALL) -e .; fi
	
	if test "$(VENV_SYMLINK)" != ""; then rm -f "$(ROOT_DIR)/$(VENV_SYMLINK)" ; ln -s "$(VENV_DIR)" "$(ROOT_DIR)/$(VENV_SYMLINK)"; fi
	@touch "$@"
	@$(HEADER2) "$(VENV_DIR) (devenv) created"


$(VENV_DIR)/runenv: $(REQS_DIR)/requirements.txt
	@$(HEADER2) "Creating $(VENV_DIR) (runenv) from $^"
	rm -Rf "$(VENV_DIR)"
	$(_MAKE_VIRTUALENV) "$(VENV_DIR)"
	if test -f "$(REQS_DIR)/prerequirements.txt"; then $(ENTER_VENV) && $(_PIP_INSTALL) -r "$(REQS_DIR)/prerequirements.txt"; fi
	$(ENTER_VENV) && $(_PIP_INSTALL) -r "$<"
	
	if test "$(VENV_SYMLINK)" != ""; then rm -f "$(ROOT_DIR)/$(VENV_SYMLINK)" ; ln -s "$(VENV_DIR)" "$(ROOT_DIR)/$(VENV_SYMLINK)"; fi
	@touch "$@"
	@$(HEADER2) "$(VENV_DIR) (runenv) created"


_remove_devenv::
	if test "$(VENV_SYMLINK)" != ""; then rm -f "$(ROOT_DIR)/$(VENV_SYMLINK)"; fi
	rm -Rf "$(VENV_DIR)"

_remove_runenv::
	if test "$(VENV_SYMLINK)" != ""; then rm -f "$(ROOT_DIR)/$(VENV_SYMLINK)"; fi
	rm -Rf "$(VENV_DIR)"

################
##### lint #####
################
.PHONY: lint_black
lint_black:
	@$(ENTER_VENV) && $(LINTER) black "$(BLACK)" "$(_APP_AND_TEST_DIRS)" "$(BLACK) --help" "$(BLACK_LINT_OPTIONS)" "ERROR detected with black reformater => try to execute 'make reformat' to fix this?"

.PHONY: lint_isort
lint_isort:
	@$(ENTER_VENV) && $(LINTER) isort "$(ISORT)" "$(_APP_AND_TEST_DIRS)" "$(ISORT) --help" "$(ISORT_LINT_OPTIONS)" "ERROR detected with isort reformater => try to execute 'make reformat' to fix this?"

.PHONY: lint_flake8
lint_flake8:
	@$(ENTER_VENV) && $(LINTER) flake8 "$(FLAKE8)" "$(_APP_AND_TEST_DIRS)" "$(FLAKE8) --help" "$(FLAKE8_LINT_OPTIONS)"

.PHONY: lint_pylint
lint_pylint:
	@$(ENTER_VENV) && $(LINTER) pylint "$(PYLINT)" "$(_APP_AND_TEST_DIRS)" "$(PYLINT) --help" "$(PYLINT_LINT_OPTIONS)"

.PHONY: lint_mypy
lint_mypy:
	@$(ENTER_VENV) && $(LINTER) mypy "$(MYPY)" "$(_APP_AND_TEST_DIRS)" "$(MYPY) --help" "$(MYPY_LINT_OPTIONS)"

.PHONY: lint_bandit
lint_bandit:
	@$(ENTER_VENV) && $(LINTER) bandit "$(BANDIT)" "$(_APP_AND_TEST_DIRS)" "$(BANDIT) --help" "$(BANDIT_LINT_OPTIONS)"

.PHONY: lint_imports
lint_imports:
	@$(ENTER_VENV) && $(LINTER) lint-imports "$(LINTIMPORTS)" "--config $(LINTIMPORTS_CONF_FILE)" "$(LINTIMPORTS) --help" ""

.PHONY: lint_safety_run lint_safety_dev
lint_safety_run:
	@$(ENTER_VENV) && $(LINTER) "safety (runtime deps)" "$(SAFETY)" "$(REQS_DIR)/requirements.txt" "$(SAFETY) --help" "check -r"

lint_safety_dev:
	@$(ENTER_VENV) && $(LINTER) "safety (dev deps)" "$(SAFETY)" "$(REQS_DIR)/devrequirements.txt" "$(SAFETY) --help" "check -r"

_lint:: lint_black lint_isort lint_flake8 lint_pylint lint_mypy lint_bandit lint_imports lint_safety_run lint_safety_dev

####################
##### reformat #####
####################
.PHONY: reformat_black
reformat_black: ## Reformat sources and tests with black
	@$(ENTER_VENV) && $(REFORMATER) "black" "$(BLACK)" "$(_APP_AND_TEST_DIRS)" "$(BLACK) --help" "$(BLACK_REFORMAT_OPTIONS)"

.PHONY: reformat_isort
reformat_isort: ## Reformat sources and tests with isort
	@$(ENTER_VENV) && $(REFORMATER) "isort" "$(ISORT)" "$(_APP_AND_TEST_DIRS)" "$(ISORT) --help" "$(ISORT_REFORMAT_OPTIONS)"

_reformat:: reformat_black reformat_isort

############################
##### tests / coverage #####
############################
.PHONY: check_pytest
check_pytest: ## Check with pytest
	@$(ENTER_VENV) && export PYTHONPATH=.:$${PYTHONPATH} && $(CHECKER) "pytest" "$(PYTEST)" "$(TEST_DIRS)" "$(PYTEST) --help" "$(PYTEST_CHECK_OPTIONS)"

.PHONY: coverage_pytest
coverage_pytest: ## Execute unit-tests and show coverage on console (with pytest)
	@$(ENTER_VENV) && export PYTHONPATH=.:$${PYTHONPATH} && $(CHECKER) "pytest" "$(PYTEST)" "$(TEST_DIRS)" "$(PYTEST) --help" "$(PYTEST_COVERAGE_OPTIONS)"

_check:: check_pytest
_coverage:: coverage_pytest

#####################
##### packaging #####
#####################
.PHONE: before_wheel wheel before_sdist sdists upload
before_sdist::
before_wheel::
wheel:: devenv before_wheel ## Build wheel (packaging)
	$(ENTER_VENV) && python setup.py bdist_wheel
sdist:: devenv before_sdist ## Build sdist (packaging)
	$(ENTER_VENV) && python setup.py sdist
upload:: devenv sdist  ## Upload to Pypi
	@if test "$(TWINE_USERNAME)" = ""; then echo "TWINE_USERNAME is empty"; exit 1; fi
	@if test "$(TWINE_PASSWORD)" = ""; then echo "TWINE_PASSWORD is empty"; exit 1; fi
	@if test "$(TWINE_REPOSITORY)" = ""; then echo "TWINE_REPOSITORY is empty"; exit 1; fi
	@$(ENTER_VENV) && $(TWINE) --help || ( echo "ERROR: twine is not installed" ; exit 1 )
	$(ENTER_VENV) && $(TWINE) upload $(TWINE_UPLOAD_EXTRA_OPTIONS) --repository-url "$(TWINE_REPOSITORY)" --username "$(TWINE_USERNAME)" --password "$(TWINE_PASSWORD)" dist/*

################
##### misc #####
################
_debug::
	@echo "PYTHON=$(PYTHON)"
	@echo "_PYTHON_BIN=$(_PYTHON_BIN)"
	@echo "_PYTHON_URL=$(_PYTHON_URL)"
	@echo "REQS_DIR=$(REQS_DIR)"

_clean::
	rm -Rf "$(TMP_VENV_DIR)" htmlcov *.egg-info .mypy_cache .pytest_cache coverage.xml .coverage
	if test "$(REMOVE_DIST)" = "1"; then rm -Rf dist; fi
	if test "$(REMOVE_BUILD)" = "1"; then rm -Rf build; fi
	find . -type d -name __pycache__ -exec rm -Rf {} \; >/dev/null 2>&1 || true

_distclean::
	if test "$(VENV_SYMLINK)" != ""; then rm -Rf "$(VENV_SYMLINK)"; fi
