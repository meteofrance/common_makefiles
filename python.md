








# Doc





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



- Default: `$(BLACK_REFORMAT_OPTIONS) --quiet`


    

    
        
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


    



