# Basique

Indépendamment du type du projet (python, bash...), voici les quelques "targets" (cibles) toujours disponibles implémenté par l'inclusion de `common_makefile.mk` dans votre `Makefile`.

## make help

Affiche la liste des "targets" (cibles) disponibles et une aide succinte.

## make

La target par défaut est positionnée à `all`.

## make all

Cette cible peut être overridée (avec la syntaxe `all::`) :

- soit par un "common makefile" particulier (python par exemple)
- soit par votre propre `Makefile``

Dans son comportement par défaut, elle est responsable de déployer des scripts utiles au fonctionnement des "common makefiles" en général et d'instancier un environnement d'exécution
(appelé `runenv`) ou un environnement de développement (appelé `devenv`). Par défaut, c'est un
environnement d'exécution qui est créé/mis à jour dans ce cas. `make devenv` permet de basculer
sur un environnement de développement.

## make devenv

Instancie un environnement de développement (`devenv`) par rapport à un environement de simple exécution (`runenv`). La différence n'a pas vraiment de sens au niveau du `commmon_makefile.mk` mais par exemple si vous avez également chargé `python_makefile.mk`, vous aurez la possibilité d'exprimer (et donc d'installer) des dépendances spécifiques à l'environnement de développement.

Cette cible `devenv` est automatiquement en prérequis de la plupart des autres, notamment : `lint`, `reformat`, `coverage_*`, `check`. Dans la plupart des cas, il n'est donc pas réellement nécessaire de
l'invoquer explicitement.

## make runenv

Instancie un environnement d'exécution (`runenv`) par rapport à un environement de développement  (`devenv`). Voir la cible `make devenv` pour plus de détails.

??? question "ça sert à quoi un environnement d'exécution dans un Makefile ?"
    Le `Makefile` étant un outil de développement, la présence d'une distinction entre un environnement
    d'exécution simple et un environnement de développement peut sembler inutile mais cela permet différentes choses comme par exemple tester simplement le fonctionnement de son projet sans toutes
    les dépendances de développement.

## make lint

Execute les "linters" configurés sur le projet.

!!! note "Note"
    Selon les cas, cette cible peut ne rien faire du tout (aucun linter configuré).

## make reformat

Reformate le projet avec les reformaters configurés.

!!! note "Note"
    Selon les cas, cette cible peut ne rien faire du tout (aucun reformater configuré).

## make check

Execute les tests configurés.

!!! note "Note"
    Selon les cas, cette cible peut ne rien faire du tout (aucun outil de test configuré).

## make clean

Nettoie des fichiers temporaires.

## make distclean

Nettoie des fichiers temporaires de manière plus agressive, notamment les outils automatiquement téléchargés,
les environnements virtuels constitués...

!!! note "Note"
    La cible "distclean" invoque en dépendance la cible "clean".

## make coverage_console

Calcule une couverture du code par les tests et affiche le résultat dans la console.

!!! note "Note"
    Selon les cas, cette cible peut ne rien faire du tout (aucun outil de test/coverage configuré).

## make coverage_html

Calcule une couverture du code par les tests et fabrique un site statique HTML avec les détails.

!!! note "Note"
    Selon les cas, cette cible peut ne rien faire du tout (aucun outil de test/coverage configuré).

## make coverage_sonar

Calcule une couverture du code par les tests et fabrique un livrable pour intégration dans [SonarQube](https://www.sonarqube.org/).

!!! note "Note"
    Selon les cas, cette cible peut ne rien faire du tout (aucun outil de test/coverage configuré).

## make refresh_common_makefiles

Met à jour le répertoire `.common_makefiles` par rapport à la version disponible
sur le site de référence (sur github.com).

L'URL de référence est donné par la variable : `COMMON_MAKEFILES_GIT_URL` (url git)
et la branche utilisée par la variable `COMMON_MAKEFILES_GIT_BRANCH`.
