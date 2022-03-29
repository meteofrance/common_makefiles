






# Doc

## Targets ready to use

*Note: you can't override these targets but you can use them!*


    

    

    


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



## Overridable variables

*Note: you can override/extend these variables in your own `Makefile`*


