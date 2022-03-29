








# Doc









## Overridable variables

*Note: you can override/extend these variables in your own `Makefile`*


    
        
### SHELLCHECK


**(note: this variable must be specifically overriden BEFORE incuding any common makefiles)**



```
shellcheck linter configuration:
AUTO    => auto-download shellcheck tool
(empty) => disable shellcheck linter
(path)  => disable auto-download and use this binary
```



- Default: `AUTO`


    

    
        
### SHELLCHECK_ARGS




```
shellcheck linter extra options
```



- Default: `(empty)`


    

    
        
### SHELLCHECK_URL




```
shellcheck download url
```



- Default: `https://github.com/koalaman/shellcheck/releases/download/stable/shellcheck-stable.linux.x86_64.tar.xz`


    

    
        
### SHELLCHECK_FILES




```
shellcheck files to check
(by default, all *.sh files are checked)
```



- Default: `$(shell find "$(ROOT_DIR)" -type f -name "*.sh" |grep -v "^$(ROOT_DIR)/\.tools/" |grep -v "^$(ROOT_DIR)/\.tmp/" |grep "[a-zA-Z0-9]" |xargs)`


    



