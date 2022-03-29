






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

    

    

    

    
        
### tests

```
Simple alias for "check" target

```

- Dependencies: `check`

    


## Extendable targets

*Note: you can extend these targets in your own `Makefile` with `target_name::` syntax*


    
        
### clean

```
Clean build and temporary files

```

- Dependencies: `before_clean`

    

    
        
### refresh

```
Refresh all things

```

- Dependencies: `before_refresh refresh_common_makefiles`

    

    

    

    
        
### lint

```
Lint the code

```

- Dependencies: `before_lint`

    

    
        
### reformat

```
Reformat sources and tests

```

- Dependencies: `before_reformat`

    

    


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


    

