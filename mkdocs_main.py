def define_env(env):
    env.variables["SHELLCHECK"] = "[ShellCheck](https://github.com/koalaman/shellcheck)"
    env.variables[
        "USE_COMMON"
    ] = "[fonctionnalités communes](/40-utilisation/10_common/)"
    env.variables["REF_COMMON"] = "[référence (common)](/90-reference/common_makefile)"
    env.variables["REF_SHELL"] = "[référence (shell)](/90-reference/shell_makefile)"
    env.variables["BLACK"] = "[black](https://black.readthedocs.io/)"
    env.variables["ISORT"] = "[isort](https://pycqa.github.io/isort/)"
    env.variables["FLAKE8"] = "[flake8](https://flake8.pycqa.org/)"
    env.variables["PYLINT"] = "[pylint](https://pylint.pycqa.org/)"
    env.variables["MYPY"] = "[mypy](https://mypy.readthedocs.io/)"
