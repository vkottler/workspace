.PHONY: all clean

.DEFAULT_GOAL  := all update
PROJ           := workspace
$(PROJ)_DIR    := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

update:
	git submodule update --init --recursive

-include $($(PROJ)_DIR)/mk/conf.mk

all: $(GRIP_PREFIX)render

clean:
	@rm -rf $(BUILD_DIR)
