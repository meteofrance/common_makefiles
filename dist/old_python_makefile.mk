export PYTHONPATH=

$(VENV_DIR)/.setup_develop: $(wildcard setup.py)
	if test "$(SETUP_DEVELOP)" != "" -a -f setup.py; then $(ENTER_VENV) && $(SETUP_DEVELOP); fi
	@mkdir -p $(VENV_DIR) ; touch $@

_check_app_dirs:
	@if test "$(APP_DIRS)" = ""; then echo "ERROR: override APP_DIRS variable in your Makefile" && exit 1; fi