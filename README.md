# Common Makefiles

## Qu'est ce que c'est ?

Ce repository héberge des [Makefiles](https://fr.wikipedia.org/wiki/Make) comuns afin de factoriser certaines pratiques de développement.

## Comment les installer dans votre repository ?

Voici la commande à copier/coller pour installer la dernière version sur votre repository.

```bash
bash -c "$(curl -fsSLk https://raw.githubusercontent.com/meteofrance/common_makefiles/main/install.sh)"
```

Si vous n'avez pas confiance dans cette dernière commande (ou si vous préférez maitriser exactement ce qui est fait),
vous pouvez simplement cloner ce repository et copier le sous-répertoire `dist` à la racine de votre projet sous le 
nom `.common_makefiles`.

Ensuite, créez (ou modifiez s'il existe déjà) un fichier `Makefile` à la racine de votre projet contenant :

### Pour un projet Python

```Makefile
include .common_makefiles/python_makefile.mk

APP_DIRS={your app directory name}
TEST_DIRS={your tests directory name}
```

### Pour un projet shell

```Makefile
include .common_makefiles/shell_makefile.mk
```

### Pour un projet générique (probablement peu utile)

```Makefile
include .common_makefiles/common_makefile.mk
```

## Comment les mettre à jour ?

Si vous avez configuré votre `Makefile` comme décrit ci-dessus, vous pouvez mettre à jour vos "common makefiles"
à partir de ce repository en lançant un simple :

```
make refresh_common_makefiles
```

Sinon, vous pouvez supprimer le répertoire `.common_makefiles` et recommencer la procédure d'installation.

## Comment configurer ?

### Dans tous les cas

Au niveau de votre `Makefile`, vous pouvez overrider les variables suivantes :

```
GIT
WGET
COMMON_MAKEFILES_GIT_URL
```

La documentation de chaque variable est lisible dans [`.common_makefiles/common_makefile.mk`](dist/common_makefile.mk). **Les variables non documentées
ne doivent pas être overridées.**

Exemple :

```Makefile
include .common_makefiles/common_makefile.mk

GIT=/usr/local/bin/mygit

# [...]
```

### Pour un projet shell

Au niveau de votre `Makefile`, vous pouvez overrider (en outre) les variables suivantes :

```
SHELLCHECK (à overrider AVANT l'include)
SHELLCHECK_ARGS
SHELLCHECK_URL
SHELLCHECK_FILES
```

La documentation de chaque variable est lisible dans [`.common_makefiles/shell_makefile.mk`](dist/shell_makefile.mk). **Les variables non documentées
ne doivent pas être overridées.**

```Makefile
SHELLCHECK=/opt/shellcheck/bin/myshellcheck
include .common_makefiles/shell_makefile.mk

GIT=/usr/local/bin/mygit
SHELLCHECK_FILES=myshell.sh myshell2.sh

# [...]
```
