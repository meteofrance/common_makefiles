








# shell_makefile.mk



## Targets ready to use

!!! note "Note"
    You can't override these targets but you can use them!


    
        
### lint_shellcheck


```
Lint the code with shellcheck
```




    










## Overridable variables

!!! note "Note"
    you can use/override/extend these variables in your own `Makefile`.


    
        
### SHELLCHECK


!!! warning ""
    This variable must be specifically overriden **BEFORE incuding any common makefiles**



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


    



