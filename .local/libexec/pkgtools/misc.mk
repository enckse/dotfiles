SHELLCHECK_VERSION := v0.10.0
SHELLCHECK_HASH    := bbd2f14826328eee7679da7221f2bc3afb011f6a928b848c80c321f6046ddf81

TARGETS            := container shellcheck
WORKDIR            := $(CACHE)/misc
SUM                := $(WORKDIR)/sum

SC_BINARIES        := $(WORKDIR)/shellcheck.$(SHELLCHECK_VERSION)
SC_TAR             := $(SC_BINARIES).tar.xz
SC_BIN             := $(SC_BINARIES)/shellcheck

.PHONY: $(TARGETS)

all: $(TARGETS)

container:
	@command -v container >/dev/null && container --generate-completion-script $(SH) | sed 's/^\_container$$/compdef _container container/g' > $(COMPLETIONS)/container-complete.sh

shellcheck:
	@mkdir -p $(WORKDIR)
	@make -f $(LIB)/devel.mk \
		NAME=shellcheck \
		URL="https://github.com/koalaman/shellcheck/releases/download/$(SHELLCHECK_VERSION)/shellcheck-$(SHELLCHECK_VERSION).$(OS).$(ALTARCH).tar.xz" \
		TAR=$(SC_TAR) \
		HASH=$(SHELLCHECK_HASH) \
		SUM=$(SUM) \
		TEST="-x $(SC_BIN)" \
		BIN="$(SC_BINARIES)" \
		MAKE_CMD="make -f $(LIB)/devel.mk $(MAKE_ARGS)"
	@ln -sf $(SC_BIN) $(LOCAL_BIN)/shellcheck
