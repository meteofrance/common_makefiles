








# Doc



## Targets ready to use

*Note: you can't override these targets but you can use them!*


    
        
### devenv


```
Prepare dev environment
```


- Dependencies: `$(DEVENV_FILE)`

    

    
        
### runenv


```
Prepare run environment
```


- Dependencies: `$(RUNENV_FILE)`

    

    
        
### lint


```
Lint the code
```


- Dependencies: `before_lint _lint custom_lint _after_lint`

    

    

    

    
        
### reformat


```
Reformat sources and tests
```


- Dependencies: `before_reformat _reformat custom_reformat _after_reformat`

    

    

    

    
        
### clean


```
Clean build and temporary files
```


- Dependencies: `before_clean _clean custom_clean _after_clean`

    

    

    

    
        
### check


```
Execute tests
```


- Dependencies: `before_check _check custom_check _after_check`

    

    

    

    
        
### tests


```
Simple alias for "check" target
```


- Dependencies: `check`

    

    
        
### refresh


```
Refresh all things
```


- Dependencies: `before_refresh _refresh custom_refresh _after_refresh`

    

    
        
### refresh_common_makefiles


```
Refresh common makefiles from repository
```


- Dependencies: ``

    

    
        
### coverage_console


```
Execute unit-tests and show coverage on console
```


- Dependencies: `before_coverage_console _coverage_console custom_coverage_console _after_coverage_console`

    

    

    

    
        
### coverage


```
simple alias to coverage_console
```


- Dependencies: `coverage_console`

    

    
        
### coverage_html


```
Execute unit-tests and show coverage in html
```


- Dependencies: `before_coverage_html _coverage_html custom_coverage_html _after_coverage_html`

    

    

    

    
        
### coverage_sonar


```
Execute unit-tests and compute coverage for sonarqube
```


- Dependencies: `before_coverage_sonar _coverage_sonar custom_coverage_sonar _after_coverage_sonar`

    

    

    

    
        
### coverage_xml


```
simple alias of coverage_sonar target
```


- Dependencies: `coverage_sonar`

    

    






## Extendable targets

*Note: you can extend these targets in your own `Makefile` with `target_name::` syntax*


    

    

    

    
        
### before_lint


```
target executed before linting
```


- Dependencies: `devenv`

    

    
        
### custom_lint


```
custom linting target
```


- Dependencies: ``

    

    

    
        
### before_reformat


```
target executed before reformating
```


- Dependencies: `devenv`

    

    
        
### custom_reformat


```
custom reformating target
```


- Dependencies: ``

    

    

    
        
### before_clean


```
target executed before cleaning
```


- Dependencies: ``

    

    
        
### custom_clean


```
custom reformating target
```


- Dependencies: ``

    

    

    
        
### before_check


```
target executed before tests
```


- Dependencies: `devenv`

    

    
        
### custom_check


```
custom check target
```


- Dependencies: ``

    

    

    

    

    

    
        
### before_coverage_console


```
target executed before coverage_console
```


- Dependencies: `devenv`

    

    
        
### custom_coverage_console


```
custom coverage_console target
```


- Dependencies: ``

    

    

    

    
        
### before_coverage_html


```
target executed before coverage_html
```


- Dependencies: `devenv`

    

    
        
### custom_coverage_html


```
custom coverage_html target
```


- Dependencies: ``

    

    

    
        
### before_coverage_sonar


```
target executed before coverage_sonar
```


- Dependencies: `devenv`

    

    
        
### custom_coverage_sonar


```
custom coverage_sonar target
```


- Dependencies: ``

    

    

    
        
### _debug


```
Dump common_makefiles configuration
```


- Dependencies: ``

    






## Read-only variables

*Note: NEVER try to override these variables*


    

    

    

    

    
        
### ROOT_DIR




```
Directory containing the "Makefile" (probably the root directory of the project)
```



- Default: `$(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))`


    

    
        
### ROOT_TMP




```
Temporary directory (local to the project)
```



- Default: `$(ROOT_DIR)/.tmp`


    

    
        
### ROOT_TOOLS




```
Tools directory (local to the project)
```



- Default: `$(ROOT_DIR)/.tools`


    

    
        
### ROOT_COMMON




```
Common makefiles directory
```



- Default: `$(ROOT_DIR)/.common_makefiles`


    

    

    

    

    






## Overridable variables

*Note: you can override/extend these variables in your own `Makefile`*


    
        
### GIT




```
Binary to use for git
```



- Default: `git`


    

    
        
### WGET




```
Binary to use for wget
```



- Default: `wget`


    

    
        
### COMMON_MAKEFILES_GIT_URL




```
Common makefiles git url (for refresh_makefiles target)
```



- Default: `http://github.com/meteofrance/common_makefiles.git`


    

    
        
### COMMON_MAKEFILES_GIT_BRANCH




```
Common makefiles git branch (for refresh_makefiles target)
```



- Default: `main`


    

    

    

    

    

    
        
### DEVENV_FILE




```
Devenv flag file (if it exists, the dev env is set up)
```



- Default: `$(ROOT_DIR)/.devenv`


    

    
        
### RUNENV_FILE




```
Runenv flag file (if it exists, the run env is set up)
```



- Default: `$(ROOT_DIR)/.runenv`


    

    
        
### DEVENV_PREREQ




```
Devenv prerequisite list (use += to add some targets)
```



- Default: `(empty)`


    

    
        
### RUNENV_PREREQ




```
Runenv prerequisite list (use += to add some targets)
```



- Default: `(empty)`


    



