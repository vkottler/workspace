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

$($(PROJ)_DIR)/local/configs: $(BUILD_DIR)/init.txt
	ln -s $($(PROJ)_DIR)/vkottler/local/configs $@

$($(PROJ)_DIR)/scripts/$(PROJ):
	ln -s $($(PROJ)_DIR)/$(PROJ) $@

$(BUILD_DIR)/init.txt:
	git submodule update --init --recursive
	touch $@

env: $(BUILD_DIR)/init.txt $($(PROJ)_DIR)/dotfiles $($(PROJ)_DIR)/third-party \
     $($(PROJ)_DIR)/scripts/$(PROJ) $($(PROJ)_DIR)/local/configs

edit: $(PY_PREFIX)edit env

py-script-%: | $(VENV_CONC) env
	cd $($(PROJ)_DIR) && $(PYTHON) $($(PROJ)_DIR)/scripts/$*.py

update: py-script-pull_all

docs: py-script-package_pydoc

clean:
	@rm -rf $(BUILD_DIR)
