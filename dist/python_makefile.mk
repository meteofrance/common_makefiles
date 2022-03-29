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
BLACK_LINT_OPTIONS?=$(BLACK_REFORMAT_OPTIONS) --quiet

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
PYTEST_COVERAGE_OPTIONS?=--cov=$(APP_DIRS)

#+ pytest options (for coverage html)
PYTEST_COVERAGE_HTML_OPTIONS?=--cov-report=html

#+ pytest options (for coverage html)
PYTEST_COVERAGE_CONSOLE_OPTIONS?=

#+ pytest options (for coverage sonarqube)
PYTEST_COVERAGE_SONAR_OPTIONS?=--cov-report=xml

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

#+ pip trusted hosts
#+ (override it with += to add some trusted hosts)
PIP_TRUSTED_HOSTS+=pypi.org files.pythonhosted.org

#+ virtualenv directory
VENV_DIR?=$(ROOT_DIR)/venv

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
else ifeq ($($PYTHON), AUTO_3_10)
	RUNENV_PREREQ+=$(ROOT_TOOLS)/python/bin/python3.10
	DEVENV_PREREQ+=$(ROOT_TOOLS)/python/bin/python3.10
	_PYTHON_BIN=$(ROOT_TOOLS)/python/bin/python3.10
	_PYTHON_URL=$(PYTHON_3_10_URL)
else
	_PYTHON_BIN=$(shell which $(PYTHON))
endif

$(ROOT_TOOLS)/python/bin/python3:
	@mkdir -p "$(ROOT_TOOLS)"
	@mkdir -p "$(ROOT_TMP)"
	@rm -Rf "$(ROOT_TOOLS)/python"
	$(WGET) -O "$(ROOT_TMP)/python.tar.gz" "$(_PYTHON_URL)"
	cd "$(ROOT_TOOLS)" && zcat "$(ROOT_TMP)/python.tar.gz" |tar xf -

$(ROOT_TOOLS)/python/bin/python3.8:
	@rm -Rf $(ROOT_TOOLS)/python
	@$(MAKE) $(ROOT_TOOLS)/python/bin/python3

$(ROOT_TOOLS)/python/bin/python3.9:
	@rm -Rf $(ROOT_TOOLS)/python
	@$(MAKE) $(ROOT_TOOLS)/python/bin/python3

$(ROOT_TOOLS)/python/bin/python3.10:
	@rm -Rf $(ROOT_TOOLS)/python
	@$(MAKE) $(ROOT_TOOLS)/python/bin/python3


########################################
##### venv/requirements management #####
########################################
_PIP=pip3
_MAKE_VIRTUALENV=$(_PYTHON_BIN) -m venv
ENTER_TEMP_VENV=. $(VENV_DIR).temp/bin/activate
## "enter virtualenv" variable
## you can use it in your Makefile scripts, for example:
## $(ENTER_VENV) && pip freeze
ENTER_VENV=. $(VENV_DIR)/bin/activate
_PIP_INDEX_URL_OPT=$(if $(PIP_INDEX_URL),--index-url $(PIP_INDEX_URL),)
_PIP_EXTRA_INDEX_URL_OPT=$(if $(PIP_EXTRA_INDEX_URL),--extra-index-url $(PIP_EXTRA_INDEX_URL),)
_PIP_TRUSTED_OPT=$(addprefix --trusted-host ,$(PIP_TRUSTED_HOSTS))
_PIP_INSTALL=$(_PIP) $(PIP_COMMON_OPTIONS) install $(_PIP_INDEX_URL_OPT) $(_PIP_EXTRA_INDEX_URL_OPT) $(_PIP_TRUSTED_OPT)
_PIP_FREEZE=$(_PIP) $(PIP_COMMON_OPTIONS) freeze
_PREREQ=
_PREDEVREQ=
ifneq ($(wildcard $(REQS_DIR)/prerequirements-notfreezed.txt),)
	_PREREQ+=$(REQS_DIR)/prerequirements.txt
endif
ifneq ($(wildcard $(REQS_DIR)/forced-requirements.txt),)
	_PREREQ+=$(REQS_DIR)/forced-requirements.txt
endif
ifneq ($(wildcard $(REQS_DIR)/predevrequirements-notfreezed.txt),)
	_PREDEVREQ+=$(REQS_DIR)/predevrequirements.txt
endif
DEVENV_PREREQ+=$(REQS_DIR)/devrequirements.txt
RUNENV_PREREQ+=$(REQS_DIR)/requirements.txt

.PHONY: devvenv

## simple alias of devenv target
devvenv: devenv

$(REQS_DIR)/prerequirements.txt: $(REQS_DIR)/prerequirements-notfreezed.txt
	rm -Rf "$(VENV_DIR).temp"
	$(_MAKE_VIRTUALENV) "$(VENV_DIR).temp"
	$(ENTER_TEMP_VENV) && $(_PIP_INSTALL) -r "$<"
	$(ENTER_TEMP_VENV) && $(_PIP_FREEZE) >"$@"
	rm -Rf "$(VENV_DIR).temp"

$(REQS_DIR)/predevrequirements.txt: $(REQS_DIR)/predevrequirements-notfreezed.txt
	rm -Rf "$(VENV_DIR).temp"
	$(_MAKE_VIRTUALENV) "$(VENV_DIR).temp"
	$(ENTER_TEMP_VENV) && $(_PIP_INSTALL) -r "$<"
	$(ENTER_TEMP_VENV) && $(_PIP_FREEZE) >"$@"
	rm -Rf "$(VENV_DIR).temp"

$(REQS_DIR)/devrequirements.txt: $(REQS_DIR)/devrequirements-notfreezed.txt $(REQS_DIR)/requirements.txt $(PREDEVREQ)
	rm -Rf "$(VENV_DIR).temp"
	$(_MAKE_VIRTUALENV) "$(VENV_DIR).temp"
	if test -f "$(REQS_DIR)/predevrequirements.txt"; then $(ENTER_TEMP_VENV) && $(_PIP_INSTALL) -r "$(REQS_DIR)/predevrequirements.txt"; fi
	$(ENTER_TEMP_VENV) && $(_PIP_INSTALL) -r "$<"
	$(ENTER_TEMP_VENV) && $(_PIP_FREEZE) |$(_PYTHON_BIN) "$(ROOT_COMMON)/extra/python_forced_requirements_filter.py" "$(REQS_DIR)/forced-requirements.txt" >"$@"
	rm -Rf "$(VENV_DIR).temp"

$(REQS_DIR)/requirements.txt: $(REQS_DIR)/requirements-notfreezed.txt $(_PREREQ)
	rm -Rf "$(VENV_DIR).temp"
	$(_MAKE_VIRTUALENV) "$(VENV_DIR).temp"
	if test -f "$(REQS_DIR)/prerequirements.txt"; then $(ENTER_TEMP_VENV) && $(_PIP_INSTALL) -r "$(REQS_DIR)/prerequirements.txt"; fi
	$(ENTER_TEMP_VENV) && $(_PIP_INSTALL) -r "$<"
	$(ENTER_TEMP_VENV) && $(_PIP_FREEZE) |$(_PYTHON_BIN) "$(ROOT_COMMON)/extra/python_forced_requirements_filter.py" "$(REQS_DIR)/forced-requirements.txt" >"$@"
	rm -Rf "$(VENV_DIR).temp"

$(REQS_DIR)/devrequirements-notfreezed.txt:
	cp -f "$(ROOT_COMMON)/extra/devrequirements-notfreezed.txt" "$@"

$(REQS_DIR)/requirements-notfreezed.txt:
	cp -f "$(ROOT_COMMON)/extra/requirements-notfreezed.txt" "$@"

.PHONY: refresh_venv _rm_requirements
refresh_venv: remove_devenv remove_runenv _rm_requirements devenv ## Update all *requirements.txt files from *requirements-freezed.txt and pip repositories
_rm_requirements:
	rm -f $(REQS_DIR)/predevrequirements.txt
	rm -f $(REQS_DIR)/prerequirements.txt
	rm -f $(REQS_DIR)/devrequirements.txt
	rm -f $(REQS_DIR)/requirements.txt

_devenv:: $(REQS_DIR)/devrequirements.txt
	rm -Rf "$(VENV_DIR)"
	$(_MAKE_VIRTUALENV) "$(VENV_DIR)"
	if test -f "$(REQS_DIR)/predevrequirements.txt"; then $(ENTER_VENV) && $(_PIP_INSTALL) -r "$(REQS_DIR)/predevrequirements.txt"; fi
	$(ENTER_VENV) && $(_PIP_INSTALL) -r "$<"
	if test -f setup.py; then $(_PIP_INSTALL) -e .; fi

_runenv:: $(REQS_DIR)/requirements.txt
	rm -Rf "$(VENV_DIR)"
	$(_MAKE_VIRTUALENV) "$(VENV_DIR)"
	if test -f "$(REQS_DIR)/prerequirements.txt"; then $(ENTER_VENV) && $(_PIP_INSTALL) -r "$(REQS_DIR)/prerequirements.txt"; fi
	$(ENTER_VENV) && $(_PIP_INSTALL) -r "$<"

#+ target to remove the "dev env"
#+ you can add some specific things in this target
#+ (of course by default we remove completly the virtualenv)
remove_devenv::
	rm -Rf "$(VENV_DIR)"

#+ target to remove the "run env"
#+ you can add some specific things in this target
#+ (of course by default we remove completly the virtualenv)
remove_runenv::
	rm -Rf "$(VENV_DIR)"

################
##### lint #####
################
.PHONY: lint_black
lint_black:
	echo "Linting with black..."
	echo "$(BLACK) $(BLACK_LINT_OPTIONS) $(_APP_AND_TEST_DIRS)"
	@$(ENTER_VENV) && $(BLACK) $(BLACK_LINT_OPTIONS) $(_APP_AND_TEST_DIRS) || ( echo "ERROR: lint errors with black => maybe you can try 'make reformat' to fix this" ; exit 1)

.PHONY: lint_isort
lint_isort:
	echo "Linting with isort..."
	echo "$(ISORT) $(ISORT_LINT_OPTIONS) $(_APP_AND_TEST_DIRS)"
	@$(ENTER_VENV) && $(ISORT) $(ISORT_LINT_OPTIONS) $(_APP_AND_TEST_DIRS) || ( echo "ERROR: lint errors with isort => maybe you can try 'make reformat' to fix this" ; exit 1)

.PHONY: lint_flake8
lint_flake8:
	echo "Linting with flake8..."
	$(ENTER_VENV) && $(FLAKE8) $(FLAKE8_LINT_OPTIONS) $(_APP_AND_TEST_DIRS)

.PHONY: lint_pylint
lint_pylint:
	echo "Linting with pylint..."
	$(ENTER_VENV) && $(PYLINT) $(PYLINT_LINT_OPTIONS) $(_APP_AND_TEST_DIRS)

.PHONY: lint_mypy
lint_mypy:
	echo "Linting with mypy..."
	$(ENTER_VENV) && $(MYPY) $(MYPY_LINT_OPTIONS) $(_APP_AND_TEST_DIRS)

.PHONY: lint_bandit
lint_bandit:
	echo "Linting with bandit..."
	$(ENTER_VENV) && $(BANDIT) $(BANDIT_LINT_OPTIONS) $(_APP_AND_TEST_DIRS)

.PHONY: lint_imports
lint_imports:
	echo "Linting with lint-imports..."
	$(ENTER_VENV) && $(LINTIMPORTS) --config $(LINTIMPORTS_CONF_FILE)

.PHONY: lint_safety_run lint_safety_dev
lint_safety_run:
	echo "Linting with safety (runtime deps)..."
	$(ENTER_VENV) && $(SAFETY) $(SAFETY_CHECK_OPTIONS) -r "$(REQS_DIR)/requirements.txt"
lint_safety_dev:
	echo "Linting with safety (dev deps)..."
	$(ENTER_VENV) && $(SAFETY) $(SAFETY_CHECK_OPTIONS) -r "$(REQS_DIR)/devrequirements.txt"

lint::
	@test -n "$(BLACK)" && test -n "$(_APP_AND_TEST_DIRS)" && $(ENTER_VENV) && $(BLACK) --help >/dev/null 2>&1 || exit 0 ; $(MAKE) lint_black
	@test -n "$(ISORT)" && test -n "$(_APP_AND_TEST_DIRS)" && $(ENTER_VENV) && $(ISORT) --help >/dev/null 2>&1 || exit 0 ; $(MAKE) lint_isort
	@test -n "$(FLAKE8)" && test -n "$(_APP_AND_TEST_DIRS)" && $(ENTER_VENV) && $(FLAKE8) --help >/dev/null 2>&1 || exit 0 ; $(MAKE) lint_flake8
	@test -n "$(PYLINT)" && test -n "$(_APP_AND_TEST_DIRS)" && $(ENTER_VENV) && $(PYLINT) --help >/dev/null 2>&1 || exit 0 ; $(MAKE) lint_pylint
	@test -n "$(BANDIT)" && test -n "$(_APP_AND_TEST_DIRS)" && $(ENTER_VENV) && $(BANDIT) --help >/dev/null 2>&1 || exit 0 ; $(MAKE) lint_bandit
	@test -n "$(LINTIMPORTS)" && $(ENTER_VENV) && $(LINTIMPORTS) --help >/dev/null 2>&1 || exit 0 ; if test -f "$(LINTIMPORTS_CONF_FILE)"; then $(MAKE) lint_imports; fi
	@test -n "$(SAFETY)" && $(ENTER_VENV) && $(SAFETY) --help >/dev/null 2>&1 || exit 0 ; $(MAKE) lint_safety_run
	@test -n "$(SAFETY)" && $(ENTER_VENV) && $(SAFETY) --help >/dev/null 2>&1 || exit 0 ; if test "$(SAFETY_ON_DEV_DEPS)" = "1"; then $(MAKE) lint_safety_dev; fi

####################
##### reformat #####
####################
.PHONY: reformat_black
reformat_black:
	echo "Reformat with black..."
	echo "$(BLACK) $(BLACK_REFORMAT_OPTIONS) $(_APP_AND_TEST_DIRS)"
	@$(ENTER_VENV) && $(BLACK) $(BLACK_REFORMAT_OPTIONS) $(_APP_AND_TEST_DIRS)

.PHONY: reformat_isort
reformat_isort:
	echo "Reformat with isort..."
	echo "$(ISORT) $(ISORT_REFORMAT_OPTIONS) $(_APP_AND_TEST_DIRS)"
	@$(ENTER_VENV) && $(ISORT) $(ISORT_REFORMAT_OPTIONS) $(_APP_AND_TEST_DIRS)

reformat::
	@test -n "$(BLACK)" && test -n "$(_APP_AND_TEST_DIRS)" && $(ENTER_VENV) && $(BLACK) --help >/dev/null 2>&1 || exit 0 ; $(MAKE) reformat_black
	@test -n "$(ISORT)" && test -n "$(_APP_AND_TEST_DIRS)" && $(ENTER_VENV) && $(ISORT) --help >/dev/null 2>&1 || exit 0 ; $(MAKE) reformat_isort

############################
##### tests / coverage #####
############################
.PHONY: check_pytest
check_pytest:
	echo "Testing with pytest..."
	$(ENTER_VENV) && export PYTHONPATH=.:$${PYTHONPATH} && $(PYTEST) $(PYTEST_CHECK_OPTIONS) $(TEST_DIRS)

.PHONY: coverage_console_pytest
coverage_console_pytest:
	echo "Coveraging with pytest (console)..."
	$(ENTER_VENV) && export PYTHONPATH=.:$${PYTHONPATH} && $(PYTEST) $(PYTEST_COVERAGE_OPTIONS) $(PYTEST_COVERAGE_CONSOLE_OPTIONS) $(TEST_DIRS)

.PHONY: coverage_html_pytest
coverage_html_pytest:
	echo "Coveraging with pytest (html)..."
	$(ENTER_VENV) && export PYTHONPATH=.:$${PYTHONPATH} && $(PYTEST) $(PYTEST_COVERAGE_OPTIONS) $(PYTEST_COVERAGE_HTML_OPTIONS) $(TEST_DIRS)

.PHONY: coverage_sonar_pytest
coverage_sonar_pytest:
	echo "Coveraging with pytest (sonar)..."
	$(ENTER_VENV) && export PYTHONPATH=.:$${PYTHONPATH} && $(PYTEST) $(PYTEST_COVERAGE_OPTIONS) $(PYTEST_COVERAGE_SONAR_OPTIONS) $(TEST_DIRS)

check::
	@test -n "$(PYTEST)" && test -n "$(TEST_DIRS)" && $(ENTER_VENV) && $(PYTEST) --help >/dev/null 2>&1 || exit 0 ; $(MAKE) check_pytest

coverage_console::
	@test -n "$(PYTEST)" && test -n "$(TEST_DIRS)" && $(ENTER_VENV) && $(PYTEST) --help >/dev/null 2>&1 || exit 0 ; $(MAKE) coverage_console_pytest

coverage_html::
	@test -n "$(PYTEST)" && test -n "$(TEST_DIRS)" && $(ENTER_VENV) && $(PYTEST) --help >/dev/null 2>&1 || exit 0 ; $(MAKE) coverage_html_pytest

coverage_sonar::
	@test -n "$(PYTEST)" && test -n "$(TEST_DIRS)" && $(ENTER_VENV) && $(PYTEST) --help >/dev/null 2>&1 || exit 0 ; $(MAKE) coverage_sonar_pytest

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
upload:: clean devenv sdist  ## Upload to Pypi
	@if test "$(TWINE_USERNAME)" = ""; then echo "TWINE_USERNAME is empty"; exit 1; fi
	@if test "$(TWINE_PASSWORD)" = ""; then echo "TWINE_PASSWORD is empty"; exit 1; fi
	@if test "$(TWINE_REPOSITORY)" = ""; then echo "TWINE_REPOSITORY is empty"; exit 1; fi
	$(ENTER_VENV) && $(TWINE) --help || ( echo "ERROR: twine is not installed" ; exit 1 )
	$(ENTER_VENV) && $(TWINE) upload $(TWINE_UPLOAD_EXTRA_OPTIONS) --repository-url "$(TWINE_REPOSITORY)" --username "$(TWINE_USERNAME)" --password "$(TWINE_PASSWORD)" dist/*

################
##### misc #####
################
refresh::
	$(MAKE) refresh_venv

_debug::
	@echo "PYTHON=$(PYTHON)"
	@echo "_PYTHON_BIN=$(_PYTHON_BIN)"
	@echo "_PYTHON_URL=$(_PYTHON_URL)"
	@echo "REQS_DIR=$(REQS_DIR)"

clean:: remove_devenv remove_runenv
	rm -Rf $(VENV_DIR).temp htmlcov *.egg-info .mypy_cache .pytest_cache coverage.xml .coverage
	if test "$(REMOVE_DIST)" = "1"; then rm -Rf dist; fi
	if test "$(REMOVE_BUILD)" = "1"; then rm -Rf build; fi
	find . -type d -name __pycache__ -exec rm -Rf {} \; >/dev/null 2>&1 || true