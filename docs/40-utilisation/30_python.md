# Python

Ce `Makefile` étend les {{USE_COMMON}} en ajoutant notamment :

- des linters
- des reformaters
- un gestion des tests unitaires et de la couverture des tests
- une gestion des environnements d'exécution et de développements avec une gestion complète des dépendances (figées et non figées)

Exemple de `Makefile` à la racine de votre projet :

```makefile
# Configuration de l'interpréteur Python
#
# AUTO_3_8  => auto-downloade python 3.8
# AUTO_3_9  => auto-downloade python 3.9 (defaut)
# AUTO_3_10 => auto-downloade python 3.10
# python3   => utilise le binaire python3 du système (doit être présent dans le PATH système)
#
# [note: cette variable spécifique doit être définie AVANT les includes]
PYTHON=AUTO_3_9

# Toujours inclure le "common_makefile.mk"
include .common_makefiles/common_makefile.mk

# L'inclusion de ce Makefile "python_makefile.mk" apporte les 
# éléments spécifiques décrits sur cette page
include .common_makefiles/python_makefile.mk

APP_DIRS=myapp
TEST_DIRS=tests
```

Pour une arborescence classique Python du type :

```
/myproject/
    .common_makefiles/
        common_makefile.mk
        python_makefile.mk
        extra.tar
        [...]
    myapp/
        __init__.py
        mymodule.py
    tests/
        __init__.py
        test_basic.py
    Makefile
    setup.py
```
