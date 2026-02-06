MAKE    := make --no-print-directory _link
LIBEXEC := ./libexec/lib/generate

.PHONY: all

all:
	@$(MAKE) OBJECT=.bashrc
	@$(MAKE) OBJECT=.gitconfig
	@$(MAKE) OBJECT=.config/git/
	@$(MAKE) OBJECT=.config/lockbox/
	@$(MAKE) OBJECT=.config/nvim/
	@$(MAKE) OBJECT=.config/kitty/
	@$(MAKE) OBJECT=.config/ttypty/
	@$(MAKE) OBJECT=.ssh/allowed_signers
	@$(LIBEXEC) devtools
	@$(LIBEXEC) git-uncommitted
	@command -v go > /dev/null && $(LIBEXEC) go-lint && $(LIBEXEC) go-mod-updates || exit 0

_link:
	@find $(PWD)/$(OBJECT) -type d | sed 's#$(PWD)#$(HOME)#g' | xargs -I {} mkdir -p "{}"
	@for object in $(shell find $(PWD)/$(OBJECT) -type f); do \
		echo $$object | sed 's#$(PWD)/##g'; \
		ln -sf $$object $$(echo $$object | sed 's#$(PWD)#$(HOME)#g'); \
	done
