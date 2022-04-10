# Comment les installer dans votre repository ?

## Dans tous les cas

Voici la commande à copier/coller pour installer la dernière version sur votre repository.

```bash
bash -c "$(curl -fsSLk https://raw.githubusercontent.com/meteofrance/common_makefiles/main/install.sh)"
```

!!! note "Note"
    Pour utiliser cette commande, vous devez avoir `git` et `bash` installé et bénéficier d'un accès à internet.


Si vous n'avez pas confiance dans cette dernière commande (ou si vous préférez maitriser exactement ce qui est fait),
vous pouvez simplement cloner ce repository et copier le sous-répertoire `dist` à la racine de votre projet sous le
nom `.common_makefiles`.

!!! warning "N'omettez aucun fichier !"
    Attention, n'omettez aucun fichier, y compris le fichier `extra.tar`. Et commitez donc la totalité
    du répertoire `.common_makefiles` ainsi obtenu.

Ensuite, créez (ou modifiez s'il existe déjà) un fichier `Makefile` à la racine de votre projet
selon son type (voir ci-dessous). Vous devez obtenir une arborescence de ce type :

```
your_project/
    .common_makefiles/
        common_makefile.mk
        extra.tar
        [...]
    Makefile
```

## Pour un projet Python

```Makefile
include .common_makefiles/common_makefile.mk
include .common_makefiles/python_makefile.mk

APP_DIRS={your app directory name}
TEST_DIRS={your tests directory name}
```

## Pour un projet shell

```Makefile
include .common_makefiles/common_makefile.mk
include .common_makefiles/shell_makefile.mk
```

## Pour un projet générique (probablement peu utile)

```Makefile
include .common_makefiles/common_makefile.mk
```

## Pour un projet mixé

Pour un projet qui mélange plusieurs technologies, vous pouvez mixer
les include de "common makefiles". Exemple pour un projet python/shell :

```Makefile
include .common_makefiles/common_makefile.mk
include .common_makefiles/python_makefile.mk
include .common_makefiles/shell_makefile.mk
```

## A ajouter dans votre `.gitignore`

Si vous utilisez `git` dans votre project, ajoutez ces quelques lignes
à votre `.gitignore` à sa racine (quitte à créer le fichier) :

```
/.tools
/.tmp
/venv
```

Ces fichiers/répertoires sont automatiquement créés/remplis et ne doivent pas être commités.
