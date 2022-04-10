def define_env(env):
    env.variables["SHELLCHECK"] = "[ShellCheck](https://github.com/koalaman/shellcheck)"
    env.variables["BLACK"] = "[black](https://black.readthedocs.io/)"
    env.variables["ISORT"] = "[isort](https://pycqa.github.io/isort/)"
    env.variables["FLAKE8"] = "[flake8](https://flake8.pycqa.org/)"
    env.variables["PYLINT"] = "[pylint](https://pylint.pycqa.org/)"
    env.variables["MYPY"] = "[mypy](https://mypy.readthedocs.io/)"

    env.variables["USE_COMMON_LOC"] = "10_common.md"
    env.variables["REF_COMMON_LOC"] = "common_makefile.md"
    env.variables["REF_SHELL_LOC"] = "shell_makefile.md"
    env.variables["REF_PYTHON_LOC"] = "python_makefile.md"

    @env.macro
    def override_env_macro(target):
        return f"""
??? question "Comment overrider ce processus ?"
    Vous avez plusieurs points d'extension :

    - `before_{target}::` : permet d'exécuter des commandes  **AVANT** l'instanciation du `{target}`
    - `before_remove_{target}::` : permet d'exécuter des commandes **AVANT** la suppression du `{target}`
    - `custom_remove_{target}::` : permet d'exécuter des commandes **APRES** la suppression du `{target}`

    Vous pouvez également ajouter des pré-requis via la variable `{target.upper()}_PREREQ` (utilisez `+=` pour ajouter des pré-requis).
"""

    @env.macro
    def override_phony_macro(target, what):
        return f"""
??? question "Comment overrider ce processus ?"
    Vous avez plusieurs points d'extension :

    - `before_{target}::` : permet d'exécuter des commandes  **AVANT** l'appel réel des {what}.
    - `custom_{target}::` : permet de définir et exécuter vos propres {what} (qui seront exécutées automatiquement **APRES** les {what} standards).

"""
