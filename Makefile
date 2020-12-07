.PHONY: all clean

.DEFAULT_GOAL  := all
PROJ           := workspace
$(PROJ)_DIR    := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

include $($(PROJ)_DIR)/mk/conf.mk

all: $(GRIP_PREFIX)render

clean:
	@rm -rf $(BUILD_DIR)
