








# Doc



## Targets ready to use

*Note: you can't override these targets but you can use them!*


    
        
### devvenv


```
simple alias of devenv target
```


- Dependencies: `devenv`

    

    
        
### refresh_venv


```
Update all *requirements.txt files from *requirements-freezed.txt and pip repositories
```


- Dependencies: `remove_devenv remove_runenv _rm_requirements devenv`

    

    
        
### reformat_black


```
Reformat sources and tests with black
```


- Dependencies: ``

    

    
        
### reformat_isort


```
Reformat sources and tests with isort
```


- Dependencies: ``

    

    
        
### check_pytest


```
Check with pytest
```


- Dependencies: ``

    

    
        
### coverage_console_pytest


```
Execute unit-tests and show coverage on console (with pytest)
```


- Dependencies: ``

    

    
        
### coverage_html_pytest


```
Execute unit-tests and show coverage in html (with pytest)
```


- Dependencies: ``

    

    
        
### coverage_sonar_pytest


```
Execute unit-tests and compute coverage for sonarqube (with pytest)
```


- Dependencies: ``

    

    

    

    






## Extendable targets

*Note: you can extend these targets in your own `Makefile` with `target_name::` syntax*


    

    

    

    

    

    

    

    

    
        
### wheel


```
Build wheel (packaging)
```


- Dependencies: `devenv before_wheel`

    

    
        
### sdist


```
Build sdist (packaging)
```


- Dependencies: `devenv before_sdist`

    

    
        
### upload


```
Upload to Pypi
```


- Dependencies: `clean devenv sdist`

    






## Read-only variables

*Note: NEVER try to override these variables*


    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    

    
        
### ENTER_VENV




```
"enter virtualenv" variable
you can use it in your Makefile scripts, for example:
$(ENTER_VENV) && pip freeze
```



- Default: `. $(VENV_DIR)/bin/activate`


    






## Overridable variables

*Note: you can override/extend these variables in your own `Makefile`*


    
        
### PYTHON


**(note: this variable must be specifically overriden BEFORE incuding any common makefiles)**



```
python interpreter configuration:
AUTO_3_8    => auto-download python 3.8
AUTO_3_9    => auto-download python 3.9
AUTO_3_10   => auto-download python 3.10
(path)      => use this binary
```



- Default: `AUTO_3_9`


    

    
        
### PYTHON_3_8_URL




```
python 3.8 download url
```



- Default: `https://github.com/indygreg/python-build-standalone/releases/download/20220318/cpython-3.8.13+20220318-x86_64-unknown-linux-gnu-install_only.tar.gz`


    

    
        
### PYTHON_3_9_URL




```
python 3.9 download url
```



- Default: `https://github.com/indygreg/python-build-standalone/releases/download/20220318/cpython-3.9.11+20220318-x86_64-unknown-linux-gnu-install_only.tar.gz`


    

    
        
### PYTHON_3_10_URL




```
python 3.10 download url
```



- Default: `https://github.com/indygreg/python-build-standalone/releases/download/20220318/cpython-3.10.3+20220318-x86_64-unknown-linux-gnu-install_only.tar.gz`


    

    
        
### BLACK




```
black binary to use
(binary name or path) => use this binary name/path (if exists)
(empty)               => disable usage
```



- Default: `black`


    

    
        
### BLACK_REFORMAT_OPTIONS




```
black reformat options
```



- Default: `$(_MAX_LINE_LENGTH_MINUS_1)`


    

    
        
### BLACK_LINT_OPTIONS




```
black lint options
```



- Default: `$(BLACK_REFORMAT_OPTIONS) --quiet --check`


    

    
        
### ISORT




```
isort binary to use
(binary name or path) => use this binary name/path (if exists)
(empty)               => disable usage
```



- Default: `isort`


    

    
        
### ISORT_REFORMAT_OPTIONS




```
isort reformat options
```



- Default: `$(VENV_DIR)`


    

    
        
### ISORT_LINT_OPTIONS




```
isort lint options
```



- Default: `$(ISORT_REFORMAT_OPTIONS) --check-only`


    

    
        
### MAX_LINE_LENGTH




```
max line length (for linting/reformating)
```



- Default: `89`


    

    
        
### FLAKE8




```
flake8 binary to use
(binary name or path) => use this binary name/path (if exists)
(empty)               => disable usage
```



- Default: `flake8`


    

    
        
### FLAKE8_LINT_OPTIONS




```
flake8 lint options
```



- Default: `$(MAX_LINE_LENGTH)`


    

    
        
### PYLINT




```
pylint binary to use
(binary name or path) => use this binary name/path (if exists)
(empty)               => disable usage
```



- Default: `pylint`


    

    
        
### PYLINT_LINT_OPTIONS




```
pylint lint options
```



- Default: `pydantic,_ldap`


    

    
        
### MYPY




```
mypy binary to use
(binary name or path) => use this binary name/path (if exists)
(empty)               => disable usage
```



- Default: `mypy`


    

    
        
### MYPY_LINT_OPTIONS




```
mypy lint options
```



- Default: `--ignore-missing-imports`


    

    
        
### BANDIT




```
bandit binary to use
(binary name or path) => use this binary name/path (if exists)
(empty)               => disable usage
```



- Default: `bandit`


    

    
        
### BANDIT_LINT_OPTIONS




```
bandit lint options
```



- Default: `-ll -r`


    

    
        
### LINTIMPORTS




```
lint-imports binary to use
(binary name or path) => use this binary name/path (if exists)
(empty)               => disable usage
```



- Default: `lint-imports`


    

    
        
### LINTIMPORTS_CONF_FILE




```
lint-imports configuration file
```



- Default: `$(ROOT_DIR)/.importlinter`


    

    
        
### PYTEST




```
pytest binary to use
(binary name or path) => use this binary name/path (if exists)
(empty)               => disable usage
```



- Default: `pytest`


    

    
        
### PYTEST_CHECK_OPTIONS




```
pytest options (for unit testing)
```



- Default: `(empty)`


    

    
        
### PYTEST_COVERAGE_OPTIONS




```
pytest options (for coverage)
```



- Default: `$(APP_DIRS)`


    

    
        
### PYTEST_COVERAGE_HTML_OPTIONS




```
pytest options (for coverage html)
```



- Default: `html`


    

    
        
### PYTEST_COVERAGE_CONSOLE_OPTIONS




```
pytest options (for coverage html)
```



- Default: `(empty)`


    

    
        
### PYTEST_COVERAGE_SONAR_OPTIONS




```
pytest options (for coverage sonarqube)
```



- Default: `xml`


    

    
        
### TWINE




```
twine binary to use
(binary name or path) => use this binary name/path (if exists)
(empty)               => disable usage
```



- Default: `twine`


    

    
        
### TWINE_REPOSITORY




```
twine repository
```



- Default: `(empty)`


    

    
        
### TWINE_USERNAME




```
twine username
```



- Default: `(empty)`


    

    
        
### TWINE_PASSWORD




```
twine password
```



- Default: `(empty)`


    

    
        
### TWINE_UPLOAD_EXTRA_OPTIONS




```
twine extra options
```



- Default: `(empty)`


    

    
        
### SAFETY




```
safety binary to use
(binary name or path) => use this binary name/path (if exists)
(empty)               => disable usage
```



- Default: `safety`


    

    
        
### SAFETY_ON_DEV_DEPS




```
if set to 1, run also safety on dev dependencies
if set to 0 (default), safety will be run only on runtime dependencies
```



- Default: `0`


    

    
        
### SAFETY_CHECK_OPTIONS




```
safety check options
```



- Default: `(empty)`


    

    
        
### PIP_COMMON_OPTIONS




```
pip common options
```



- Default: `--disable-pip-version-check`


    

    
        
### PIP_INDEX_URL




```
pip index url
```



- Default: `(empty)`


    

    
        
### PIP_EXTRA_INDEX_URL




```
pip extra index url
```



- Default: `(empty)`


    

    
        
### PIP_TRUSTED_HOSTS




```
pip trusted hosts
(override it with += to add some trusted hosts)
```



- Default: `pypi.org files.pythonhosted.org`


    

    
        
### VENV_DIR




```
virtualenv directory
```



- Default: `$(ROOT_DIR)/venv`


    

    
        
### REQS_DIR




```
requirements dir
```



- Default: `$(ROOT_DIR)`


    

    
        
### REMOVE_DIST




```
remove "dist" directory during clean
```



- Default: `1`


    

    
        
### REMOVE_BUILD




```
remove "build" directory during clean
```



- Default: `1`


    

    
        
### APP_DIRS




```
python application dirs (space separated)
```



- Default: `(empty)`


    

    
        
### TEST_DIRS




```
tests application dirs (space separated)
```



- Default: `(empty)`


    

    
        
### EXTRA_PYTHON_FILES




```
extra python files to lint/reformat
(if they are outside of APP_DIRS/TEST_DIRS)
(space separated paths)
```



- Default: `(empty)`


    

    



