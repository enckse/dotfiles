VERSION       := v9.1.1470
HASH          := 7809607c06a53c75716d789d5282b9786d0c518a591dde6a33c0819f9a3db39c
WORKDIR       := $(CACHE)/vim
SRC           := $(WORKDIR)/$(VERSION)
TAR           := $(SRC).tar.gz
SUM           := $(WORKDIR)/sum
BIN           := $(SRC)/src/vim

TARGETS       := vim vim-plugins
VIM_PLUGINS   := $(HOME)/.config/vim/pack/plugins/start
PLUGIN        :=
PLUGIN_NAME   :=
PLUGIN_DIR    :=
ifdef PLUGIN
PLUGIN_NAME   := $(shell echo "$(PLUGIN)" | rev | cut -d "/" -f 1 | rev)
PLUGIN_DIR    := $(VIM_PLUGINS)/$(PLUGIN_NAME)
endif

.PHONY: $(TARGETS)

all: $(TARGETS)

vim:
	@echo "building: vim"
	@mkdir -p $(WORKDIR)
	@test -e $(TAR) || curl -L "https://github.com/vim/vim/archive/refs/tags/$(VERSION).tar.gz" > $(TAR)
	@echo "$(HASH)  $(TAR)" > $(SUM)
	@sha256sum --status -c $(SUM)
	@test -x $(BIN) || $(MAKE_CMD) _compile
	@ln -sf $(BIN) $(LOCAL_BIN)/vim
	@echo 'export VIM=$(SRC)' > $(ENV)/vim.sh

_compile:
	@rm -rf "$(SRC)"
	@mkdir -p $(SRC) 
	tar xf $(TAR) --strip-component=1 -C $(SRC)
	cd $(SRC); ./configure --enable-multibyte --with-tlib=ncurses --enable-terminal --disable-gui --without-x
	cd $(SRC); make 


vim-plugins:
	@echo "fetching: vim plugins"
	@mkdir -p $(VIM_PLUGINS)
	@$(MAKE_CMD) _viminstall PLUGIN="https://github.com/vim-airline/vim-airline"
	@$(MAKE_CMD) _viminstall PLUGIN="https://github.com/dense-analysis/ale"

_viminstall:
	@echo "vim plugin: $(PLUGIN_NAME)"
	@test -d $(PLUGIN_DIR) || git clone --quiet $(PLUGIN) $(PLUGIN_DIR)
	@git -C $(PLUGIN_DIR) pull --quiet
