MAKE    := make --no-print-directory _link

.PHONY: all

all:
	@$(MAKE) OBJECT=.bashrc
	@$(MAKE) OBJECT=.vars.env
	@$(MAKE) OBJECT=.gitconfig
	@$(MAKE) OBJECT=.shellrc
	@$(MAKE) OBJECT=.config/git/
	@$(MAKE) OBJECT=.config/lockbox/
	@$(MAKE) OBJECT=.config/nvim/
	@$(MAKE) OBJECT=.ssh/allowed_signers
	@$(MAKE) OBJECT=.local/bin/devtools
	@$(MAKE) OBJECT=.local/bin/git-uncommitted
	@command -v go > /dev/null && ln -sf $(PWD)/.local/bin/go-lint $(GOPATH)/bin/
	@command -v go > /dev/null && ln -sf $(PWD)/.local/bin/go-mod-updates $(GOPATH)/bin/

_link:
	@find $(PWD)/$(OBJECT) -type d | sed 's#$(PWD)#$(HOME)#g' | xargs -I {} mkdir -p "{}"
	@for object in $(shell find $(PWD)/$(OBJECT) -type f); do \
		echo $$object | sed 's#$(PWD)/##g'; \
		ln -sf $$object $$(echo $$object | sed 's#$(PWD)#$(HOME)#g'); \
	done
