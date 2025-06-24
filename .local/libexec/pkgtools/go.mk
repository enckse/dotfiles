GO            := "1.24.4"
GOPLS         := "v0.19.1"
GOTOOLS       := "v0.34.0"
STATICCHECK   := "v0.6.1"
GOFUMPT       := "v0.8.0"
REVIVE        := "v1.10.0"
LOCKBOX       := "v1.6.1"
GITTOOLS      := "v0.4.0"
RESTIC        := "v0.18.0"

TARGETS       := go binaries
GO_PKG        := $(CACHE)/go
BINARIES      := $(GO_PKG)/$(GO)
TAR           := $(GO_PKG)/$(GO).tar.gz
BIN			  := $(BINARIES)/bin
SUM           := $(GO_PKG)/sum
HASH          := 27973684b515eaf461065054e6b572d9390c05e69ba4a423076c160165336470
TOOL          :=
VERS          :=
TOOL_NAME     :=
EXISTS        :=
INSTALLED     := installed.
WAC_REPO      := $(HOME)/Store/git/private/wac.git
WAC_HASH      := $(shell git -C $(WAC_REPO) log -n 1 --format=%h)
WAC           := $(GO_PKG)/wac.$(WAC_HASH)
WAC_BINARY    := $(WAC)/target/wac
ifdef TOOL
TOOL_NAME     := $(shell echo "$(TOOL)" | sed 's|/cmd/\.\.\.||g' | rev | cut -d "/" -f 1 | rev)
EXISTS        := $(GO_PKG)/$(INSTALLED)$(TOOL_NAME).$(VERS)
endif

.PHONY: $(TARGETS)

all: $(TARGETS)

go:
	@mkdir -p $(GO_PKG)
	@make -f $(LIB)/devel.mk \
		NAME=go \
		URL="https://go.dev/dl/go$(GO).$(OS)-$(ARCH).tar.gz" \
		TAR=$(TAR) \
		HASH=$(HASH) \
		SUM=$(SUM) \
		TEST="-d $(BIN)" \
		BIN="$(BINARIES)" \
		MAKE_CMD="make -f $(LIB)/devel.mk $(MAKE_ARGS)"
	@ln -sf $(BIN)/go $(LOCAL_BIN)/

binaries:
	@$(MAKE_CMD) _goinstall VERS="$(GOFUMPT)" TOOL="mvdan.cc/gofumpt"
	@$(MAKE_CMD) _goinstall VERS="$(GOPLS)" TOOL="golang.org/x/tools/gopls"
	@$(MAKE_CMD) _goinstall VERS="$(GOPLS)" TOOL="golang.org/x/tools/gopls/internal/analysis/modernize/cmd/modernize"
	@$(MAKE_CMD) _goinstall VERS="$(REVIVE)" TOOL="github.com/mgechev/revive"
	@$(MAKE_CMD) _goinstall VERS="$(STATICCHECK)" TOOL="honnef.co/go/tools/cmd/staticcheck"
	@$(MAKE_CMD) _goinstall VERS="$(GOTOOLS)" TOOL="golang.org/x/tools/go/analysis/passes/fieldalignment/cmd/fieldalignment"
	@$(MAKE_CMD) _goinstall VERS="$(GITTOOLS)" TOOL="git.sr.ht/~enckse/git-tools/cmd/..."
	@$(MAKE_CMD) _goinstall VERS="$(LOCKBOX)" TOOL="git.sr.ht/~enckse/lockbox/cmd/lb"
	@$(MAKE_CMD) _goinstall VERS="$(RESTIC)" TOOL="github.com/restic/restic/cmd/restic"
	@test -x $(WAC_BINARY) || $(MAKE_CMD) _wac
	@install -Dm755 $(WAC_BINARY) $(LOCAL_BIN)/
	@lb completions $(SH) > "$(COMPLETIONS)/lb-completions.sh"
	@find $(GO_PKG) -maxdepth 1 -type f -mtime +1 -name "$(INSTALLED)*" -delete

_wac:
	@echo "building wac"
	rm -rf $(WAC)
	@git clone --quiet private:wac $(WAC)
	@make -C $(WAC)

_goinstall:
	@echo "go tool: $(TOOL)"
	@test -e $(EXISTS) || go install $(TOOL)@$(VERS)
	@touch $(EXISTS)
