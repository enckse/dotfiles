BAT            := "v0.25.0"
DELTA          := "0.18.2"
RG             := "14.1.1"

BAT_HASH       := b3ed5a7515545445881f1036f0cc1b708c2b86cbce01c1b4033f38e0cfcc7b3c
DELTA_HASH     := 6ba38dce9f91ee1b9a24aa4aede1db7195258fe176c3f8276ae2d4457d8170a0
RG_HASH        := 24ad76777745fbff131c8fbc466742b011f925bfa4fffa2ded6def23b5b937be

WORKDIR        := $(CACHE)/rust
SUM            := $(WORKDIR)/sum

BAT_BINARIES   := $(WORKDIR)/bat.$(BAT)
BAT_TAR        := $(BAT_BINARIES).tar.gz
BAT_BIN        := $(BAT_BINARIES)/bat
DELTA_BINARIES := $(WORKDIR)/delta.$(DELTA)
DELTA_TAR      := $(DELTA_BINARIES).tar.gz
DELTA_BIN      := $(DELTA_BINARIES)/delta
RG_BINARIES    := $(WORKDIR)/rg.$(RG)
RG_TAR         := $(RG_BINARIES).tar.gz
RG_BIN         := $(RG_BINARIES)/rg

TRIPLE   := $(ALTARCH)-$(FRIENDLY)-$(OS)

all: setup binaries

setup:
	@mkdir -p $(WORKDIR)

binaries:
	@make -f $(LIB)/devel.mk \
		NAME=bat \
		URL="https://github.com/sharkdp/bat/releases/download/$(BAT)/bat-$(BAT)-$(TRIPLE).tar.gz" \
		TAR=$(BAT_TAR) \
		HASH=$(BAT_HASH) \
		SUM=$(SUM) \
		TEST="-e $(BAT_BIN)" \
		BIN="$(BAT_BINARIES)" \
		MAKE_CMD="make -f $(LIB)/devel.mk $(MAKE_ARGS)"
	@ln -sf $(BAT_BIN) $(LOCAL_BIN)/
	@make -f $(LIB)/devel.mk \
		NAME=delta \
		URL="https://github.com/dandavison/delta/releases/download/$(DELTA)/delta-$(DELTA)-$(TRIPLE).tar.gz" \
		TAR=$(DELTA_TAR) \
		HASH=$(DELTA_HASH) \
		SUM=$(SUM) \
		TEST="-e $(DELTA_BIN)" \
		BIN="$(DELTA_BINARIES)" \
		MAKE_CMD="make -f $(LIB)/devel.mk $(MAKE_ARGS)"
	@ln -sf $(DELTA_BIN) $(LOCAL_BIN)/
	@make -f $(LIB)/devel.mk \
		NAME=ripgrep \
		URL="https://github.com/BurntSushi/ripgrep/releases/download/$(RG)/ripgrep-$(RG)-$(TRIPLE).tar.gz" \
		TAR=$(RG_TAR) \
		HASH=$(RG_HASH) \
		SUM=$(SUM) \
		TEST="-e $(RG_BIN)" \
		BIN="$(RG_BINARIES)" \
		MAKE_CMD="make -f $(LIB)/devel.mk $(MAKE_ARGS)"
	@ln -sf $(RG_BIN) $(LOCAL_BIN)/
