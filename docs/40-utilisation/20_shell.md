# Shell

Cette page étend les {{USE_COMMON}} en ajoutant notamment un linter : {{SHELLCHECK}} au shell.

Exemple de `Makefile` à la racine de votre projet :

```makefile
# Configuration du linter ShellCheck :
#
# AUTO    => auto-downloade ShellCheck depuis internet (valeur par défaut)
# (empty) => déactive ShellCheck
# (path)  => utile ce binaire qui doit être présent dans le PATH système
#
# [note: cette variable spécifique doit être définie AVANT les includes]
SHELLCHECK=AUTO

include .common_makefiles/common_makefile.mk
include .common_makefiles/shell_makefile.mk

# Liste des fichiers à passer au linter
#
# par défaut : $(shell find "$(ROOT_DIR)" -type f -name "*.sh" |grep -v "^$(ROOT_DIR)/\.tools/" |grep -v "^$(ROOT_DIR)/\.tmp/" |grep "[a-zA-Z0-9]" |xargs)
#                => liste tous les fichiers .sh (à l'exception des sous-répertoires .tools et .tmp )
# sinon      : liste des fichiers shells à passer au linter (chemins séparés par des espaces)
SHELLCHECK_FILES = src/foo.sh src/bar.sh
```

Avec ce type de configuration, l'execution de `make lint` va exécuter {{SHELLCHECK}} sur les fichiers configurés.

Le chargement de `shell_makefile.mk` va également amener une nouvelle cible : `lint_shellcheck` qui permet de n'exécuter que ce linter
(si jamais plusieurs autres linters sont configurés sous la cible `lint`).

Plus de détails quant aux possibilités/configurations : {{REF_SHELL}} mais aussi {{REF_COMMON}}.
