MAKE    := make --no-print-directory _link

.PHONY: all

all:
	@$(MAKE) OBJECT=.bashrc
	@$(MAKE) OBJECT=.gitconfig
	@$(MAKE) OBJECT=.shellrc
	@$(MAKE) OBJECT=.config/git/
	@$(MAKE) OBJECT=.config/lockbox/
	@$(MAKE) OBJECT=.config/nvim/
	@$(MAKE) OBJECT=.config/kitty/
	@$(MAKE) OBJECT=.ssh/allowed_signers
	@$(MAKE) OBJECT=.local/bin/devtools
	@$(MAKE) OBJECT=.local/bin/git-uncommitted
	@test -d $(HOME)/.opencode && $(MAKE) OBJECT=.local/bin/oc || exit 0
	@command -v go > /dev/null && $(MAKE) OBJECT=.local/bin/go-lint && $(MAKE) OBJECT=.local/bin/go-mod-updates || exit 0

_link:
	@find $(PWD)/$(OBJECT) -type d | sed 's#$(PWD)#$(HOME)#g' | xargs -I {} mkdir -p "{}"
	@for object in $(shell find $(PWD)/$(OBJECT) -type f); do \
		echo $$object | sed 's#$(PWD)/##g'; \
		ln -sf $$object $$(echo $$object | sed 's#$(PWD)#$(HOME)#g'); \
	done
