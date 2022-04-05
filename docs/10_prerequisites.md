# Pré-requis

Pour utiliser ces Makefiles, vous aurez besoin d'une distribution Linux avec les outils standards suivants :

- `make` (évidemment, dans sa version GNU)
- `wget` (pour télécharger diverses choses)
- `bash` (car toutes les "targets" sont écrites en `bash`)
- `xz` (pour décompresser certains outils téléchargés sur internet)
- `find`, `xargs` (pour chercher des fichiers)
- les outils standards unix de manipulations de texte: `cat`, `awk`, `sed`, `tr`...

Tous ces outils sont normalement préinstallés sur notre distribution Linux.

Néanmoins, si vous utilisez un container minimisé par exemple, certains peuvent manquer.

Pour installer ces dépendances :

=== "Pour une CentOS 7"

    ```
    yum -y install make wget xz findutils
    ```

=== "Pour une CentOS/Rocky 8"

    ```
    dnf -y install make wget xz findutils
    ```

Et en option :

- `git` (pour la fonctionnalité de mise à jour uniquement, vous pouvez donc vous en passer éventuellement)

Pour installer `git` :

=== "Pour une CentOS 7"

    ```
    yum -y install git
    ```

=== "Pour une CentOS/Rocky 8"

    ```
    dnf -y install git
    ```
