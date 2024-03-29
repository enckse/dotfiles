FILES   := $(shell find . -type f | cut -d '/' -f 2- | grep '^\.' | grep -v '\.git/')
DIRS    := $(shell find $(FILES) -type f -exec dirname {} \; | grep -v '^\.$$' | sort -u)

install: _dirs _files

_files:
	@for file in $(FILES) ; do \
		echo $$file; \
		ln -sf $(PWD)/$$file $(HOME)/$$file ; \
	done

_dirs:
	@for dir in $(DIRS) ; do \
		echo $$dir; \
		mkdir -p $(HOME)/$$dir ; \
	done
