# Basique

Indépendamment du type du projet (python, bash...), voici les quelques "targets" (cibles) toujours disponibles.

## make help

Affiche la liste des "targets" (cibles) disponibles et une aide succinte.

## make refresh_common_makefiles

Update `.common_makefiles` directory from github reference website.

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
