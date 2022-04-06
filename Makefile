###############################################################################
MK_INFO := https://pypi.org/project/vmklib
ifeq (,$(shell which mk))
	$(warning "No 'mk' in $(PATH), install 'vmklib' with 'pip' ($(MK_INFO))")
endif
ifndef MK_AUTO
	$(error target this Makefile with 'mk', not '$(MAKE)' ($(MK_INFO)))
endif
###############################################################################

.PHONY: env edit clean py-script-%

.DEFAULT_GOAL := update

$($(PROJ)_DIR)/dotfiles:
	ln -s ~/dotfiles

$($(PROJ)_DIR)/third-party:
	ln -s ~/third-party

env: $($(PROJ)_DIR)/dotfiles $($(PROJ)_DIR)/third-party

edit: $(PY_PREFIX)edit

py-script-%: | $(VENV_CONC) env
	cd $($(PROJ)_DIR) && $(PYTHON) $($(PROJ)_DIR)/scripts/$*.py

update: py-script-pull_all

clean:
	@rm -rf $(BUILD_DIR)
