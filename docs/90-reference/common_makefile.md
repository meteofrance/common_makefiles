








# common_makefile.mk



## Targets ready to use

!!! note "Note"
    You can't override these targets but you can use them!


    
        
### devenv


```
Prepare dev environment
```



- Dependencies: `$(EXTRA_PREREQ) $(DEVENV_FILE)`


    

    
        
### runenv


```
Prepare run environment
```



- Dependencies: `$(EXTRA_PREREQ) $(RUNENV_FILE)`


    

    
        
### lint


```
Lint the code
```



- Dependencies: `$(EXTRA_PREREQ) before_lint _lint custom_lint _after_lint`


    

    

    

    
        
### reformat


```
Reformat sources and tests
```



- Dependencies: `$(EXTRA_PREREQ) before_reformat _reformat custom_reformat _after_reformat`


    

    

    

    
        
### clean


```
Clean build and temporary files
```



- Dependencies: `$(EXTRA_PREREQ) before_clean _clean custom_clean _after_clean`


    

    

    

    
        
### distclean


```
Full clean (including common_makefiles downloaded tools/env)
```



- Dependencies: `$(EXTRA_PREREQ) clean remove_devenv remove_runenv`


    

    
        
### check


```
Execute tests
```



- Dependencies: `$(EXTRA_PREREQ) before_check _check custom_check _after_check`


    

    

    

    
        
### tests


```
Simple alias for "check" target
```



- Dependencies: `check`


    

    
        
### refresh_common_makefiles


```
Refresh common makefiles from repository
```




    

    
        
### coverage_console


```
Execute unit-tests and show coverage on console
```



- Dependencies: `$(EXTRA_PREREQ) before_coverage_console _coverage_console custom_coverage_console _after_coverage_console`


    

    

    

    
        
### coverage


```
simple alias to coverage_console
```



- Dependencies: `coverage_console`


    

    
        
### coverage_html


```
Execute unit-tests and show coverage in html
```



- Dependencies: `$(EXTRA_PREREQ) before_coverage_html _coverage_html custom_coverage_html _after_coverage_html`


    

    

    

    
        
### coverage_sonar


```
Execute unit-tests and compute coverage for sonarqube
```



- Dependencies: `$(EXTRA_PREREQ) before_coverage_sonar _coverage_sonar custom_coverage_sonar _after_coverage_sonar`


    

    

    

    
        
### coverage_xml


```
simple alias of coverage_sonar target
```



- Dependencies: `coverage_sonar`


    

    






## Extendable targets

!!! note "Note"
    You can extend these targets in your own `Makefile` with `target_name::` syntax.


    

    

    

    
        
### before_lint


```
target executed before linting
```



- Dependencies: `devenv`


    

    
        
### custom_lint


```
custom linting target
```




    

    

    
        
### before_reformat


```
target executed before reformating
```



- Dependencies: `devenv`


    

    
        
### custom_reformat


```
custom reformating target
```




    

    

    
        
### before_clean


```
target executed before cleaning
```




    

    
        
### custom_clean


```
custom reformating target
```




    

    

    

    
        
### before_check


```
target executed before tests
```



- Dependencies: `devenv`


    

    
        
### custom_check


```
custom check target
```




    

    

    

    

    
        
### before_coverage_console


```
target executed before coverage_console
```



- Dependencies: `devenv`


    

    
        
### custom_coverage_console


```
custom coverage_console target
```




    

    

    

    
        
### before_coverage_html


```
target executed before coverage_html
```



- Dependencies: `devenv`


    

    
        
### custom_coverage_html


```
custom coverage_html target
```




    

    

    
        
### before_coverage_sonar


```
target executed before coverage_sonar
```



- Dependencies: `devenv`


    

    
        
### custom_coverage_sonar


```
custom coverage_sonar target
```




    

    

    
        
### _debug


```
Dump common_makefiles configuration
```




    






## Read-only variables

!!! danger ""
    You can use them in your own `Makefile` but **NEVER try to override these variables!**


    

    

    

    

    
        
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

!!! note "Note"
    you can use/override/extend these variables in your own `Makefile`.


    
        
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



- Default: `$(ROOT_TOOLS)/devenv`


    

    
        
### RUNENV_FILE




```
Runenv flag file (if it exists, the run env is set up)
```



- Default: `$(ROOT_TOOLS)/runenv`


    

    
        
### SHOW_HELP_WITH_ALL_TARGET




```
Display help with all target
1 => yes
0 => no
```



- Default: `1`


    

    
        
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


    



