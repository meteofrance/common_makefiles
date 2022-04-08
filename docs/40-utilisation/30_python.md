# Python

## Généralités

Ce `Makefile` étend les {{USE_COMMON}} en ajoutant notamment :

- une installation automatique (sans droits root et sans perturber le reste du système) de plusieurs versions très recentes de Python grace au projet [python build standalone](https://python-build-standalone.readthedocs.io)

- une gestion des environnements d'exécution et de développements avec une gestion complète des dépendances (figées et non figées)

- des linters :
    - {{FLAKE8}}
    - {{BLACK}}
    - {{ISORT}}
    - {{PYLINT}}
    - {{MYPY}}
    - [import-linter](https://github.com/seddonym/import-linter/)
    - [bandit](https://github.com/PyCQA/bandit)
    - [safety](https://github.com/pyupio/safety)

- des reformaters :
    - {{BLACK}}
    - {{ISORT}}

- un gestion des tests unitaires et de la couverture des tests :
    - [pytest](https://docs.pytest.org/)
    - [pytest-cov](https://github.com/pytest-dev/pytest-cov)

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

## Gestion des dépendances (venv)

### Modèle

Ce `Makefile` introduit une gestion complète des dépendances et de leur cycle de vie sur le modèle suivant :

``` mermaid
graph LR
  subgraph "Utilisés à l'exécution"
  VENV["venv (en mode runenv)"]
  end
  subgraph "Automatiquement générés"
  R[requirements.txt] -- "génère précisément et<br> de façon reproductible" --> VENV
  end
  subgraph "Renseignés par le développeur"
  RNOT[requirements-notfreezed.txt] -- "génère en interrogeant<br>les versions disponibles" --> R
  F[forced-requirements.txt] -. "peut forcer certaines lignes" .-> R
  end
  style F stroke-dasharray: 5 5
```

Des dépendances sont exprimées de façon relativement laches dans le fichier `requirements-notfreezed.txt`.
Dans l'esprit, vous ne devez y lister que les dépendances explicites de votre projet sous une forme relativement lache et flexible. Par exemple : `django >=3.2,<4.0`.

A partir de ce fichier, les "common makefiles" vont fabriquer automatiquement le fichier `requirements.txt`
en interrogeant [PyPi](https://pypi.org) (et/ou d'autres repositories configurables) pour déterminer les versions exactes actuellement applicables ainsi que les dépendances de niveau supérieur (les dépendances de vos dépendances et ... récursivement). La liste complète ainsi obtenue (nom du package et version exacte) est alors consignée dans le fichier `requirements.txt`.

C'est ce fichier (et uniquement celui là) qui fabriquera [l'environnement d'exécution virtuel (venv)](https://realpython.com/python-virtual-environments-a-primer/).

Le format a utiliser pour exprimer vos dépendances dans le fichier `requirements-notfreezed.txt` est le format standard des "requirements pip" :

- https://pip.pypa.io/en/stable/reference/requirements-file-format/
- https://pip.pypa.io/en/stable/cli/pip_install/#requirement-specifiers  (plus précisément pour exprimer des contraintes de versions)

??? question "C'est quoi ce `forced-requirements.txt` optionnel ?"
    C'est une fonctionnalité avancée utile dans assez peu de cas.

    Dans certains cas, on peut souhaiter influencer la génération du `requirements.txt` et notamment le rendre un peu moins
    strict en terme de numéro de version.

    L'exemple type c'est quand parmi les dépendances, on a une dépendance qui est gérée par nous même et dont on ne veutcl
    pas préciser le numéro de version précis dans `requirements.txt` (pour, par exemple, toujours prendre la dernière). Dans ce cas, il suffit de créer un fichier `forced-requirements.txt` en utilisant le même format que `requirements-notfreezed.txt`
    contenant uniquements les lignes qu'on veut forcer. Par exemple : `malib`. De ce fait, le ligne concernant le package `malib`
    dans `requirements.txt` qui était probablement qqch du type `malib==1.2.3` sera transformée en `malib`.

### devenv

Le principe est exactement le même si le schéma est en fait un petit peu plus compliqué dans la mesure où il y a une distinction entre l'environnement d'exécution simple (`runenv`) et l'environnement de développement complet (`devenv`) qui ajoute des dépendances **en plus** requises uniquement pendant la phase de développement (des linters par exemple).

L'environnement de dev est conçu comme un simple override de l'environnement d'exécution. Donc les prérequis (noms et versions exactes) de l'environnement d'exécution forcent les dépendances de développements (qui viennent donc uniquement se rajouter).

On obtient le schéma suivant :

``` mermaid
graph LR
  subgraph "Utilisés à l'exécution"
  VENV["venv (en mode devenv)"]
  end
  subgraph "Automatiquement générés"
  R[requirements.txt] -- "force" --> D
  D[devrequirements.txt] -- "génère précisément et<br> de façon reproductible" --> VENV
  end
  subgraph "Renseignés par le développeur"
  RNOT[requirements-notfreezed.txt] -- "génère en interrogeant<br>les versions disponibles" --> R
  DNOT[devrequirements-notfreezed.txt] -- "génère en interrogeant<br>les versions disponibles" --> D
  F[forced-requirements.txt] -. "peut forcer certaines lignes" .-> R
  F[forced-requirements.txt] -. "peut forcer certaines lignes" .-> D
  end
  style F stroke-dasharray: 5 5
```

Le format et la logique d'un fichier `devrequirements-notfreezed.txt` est donc tout à fait similaire au fichier `requirements-notfreezed.txt` mais pour les dépendances spécifiques au développement. Le fichier devrait également commencer par la ligne `-r requirements.txt` pour lui dire de prendre en dépendance les versions exactes retenues pour l'environnement d'exécution.

### FAQ

!!! question "Je dois rajouter une dépendance `foo >= 1.0,<2.0` à mon projet, j'utilise quel fichier ?"
    Si c'est une dépendance qui n'est requise pour la phase de développement, ajoutez la ligne `foo >=1.0,<2.0`
    dans le fichier `devrequirements-notfreezed.txt`.

    Si c'est une dépendance qui doit être présente dans tous les cas (runtime ou devtime), ajoutez la ligne `foo >=1.0,<2.0`
    dans `requirementst-notfreezed.txt`.

!!! question "Comment je génère automatiquement les fichiers intermédiaires ou mon virtualenv ?"
    - `make runenv` pour environnement d'exécution
    - `make devenv` pour un environnement de développement
    - `make` tout court suffit également si vous avez déjà fait votre choix une première fois (runenv ou devenv)

!!! question "Comment les "common makefiles" savent s'il faut recréer les fichiers intermédiaires et/ou le virtualenv ?"
    C'est la date de modification des fichiers qui permet de déterminer ce qui est plus vieux et donc ce qui nécessite
    d'être reconstruit.

!!! question "Comment forcer une mise à jour de tous les fichiers intermédiaires et de mon virtualenv ?"
    Un `touch *requirements-notfreezed.txt` suivi d'un `make` suffit. Si vous préférez, un alias `make refresh_venv` est également
    disponible.

!!! question "Dois je commiter mes fichiers *requirements.txt ?"
    Si vous ne les commitez pas, ils seront reconstruits à chaque fois après chaque `git clone` mais ils seront reconstruits
    en tenant compte des versions disponibles (sur les repositories configurés) au moment de la reconstruction. Du coup, vous
    n'aurez pas un comportement parfaitement reproductible (votre application peut fonctionner à l'instant T1 et ne plus fonctionner
    car une dépendance incompatible aura été publiée sur internet à l'instant T2).

    Donc, oui, nous vous conseillons très fortement de les commiter.

!!! question "Comment rentrer dans le `venv` en interactif ou depuis mon `Makefile` ?"
    **En interactif**, et c'est simplement lié à la manière dont les virtualenv python fonctionnent, vous devez
    "charger" le `venv` pour en bénéficier (version python, dépendances installées...). Pour le faire, utilisez la
    commande suivante dans votre terminal :

    ````
    source venv/bin/activate
    ```
    (une fois chargé, `deactivate` permet d'en sortir ou alors relancez simplement votre terminal)

    **Depuis votre `Makefile`**, vous avez un racccourci qui consiste à rajouter `$(ENTER_VENV) && ` devant votre commande. Par ex:

    ```Makefile
    macible:
        $(ENTERVENV) && ma_commande
    ```

## Les linters / reformaters

Par défaut, si le fichier n'existe pas déjà, le Makefile va vous générer un fichier `devrequirements-notfreezed.txt` contenant
des dépendances à :

- {{FLAKE8}}
- {{BLACK}}
- {{ISORT}}
- {{PYLINT}}
- {{MYPY}}

De ce fait, un simple `make lint` va les faire passer sur votre code.

Si vous souhaitez retirer des linters, effacez simplement leur nom dans le fichier `devrequirements-notfreezed.txt`.

Vous pouvez également en ajouter. La liste des linters supportés "out of the box" est la suivante : `flake8`, `black`, `isort`, `pylint`, `mypy`, `import-linter`, `safety` et `bandit`.

??? question "Ajouter un linter/reformater non pris en charge ?"
    Si vous voulez ajouter un linter/reformater non pris en charge, vous pouvez ajouter une cible `custom_lint` et/ou `custom_reformat` qui sera automatiquement exécutée lors du `make lint` et/ou `make reformat`.

Vous pouvez également agir sur plein de paramètres de configuration (pour tuner leur comportement). Consultez la {{REF_PYTHON}}
pour plus de détails.
