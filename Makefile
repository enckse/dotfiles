IGNORE := | grep '^\.' | grep -v '^\.gitignore' | grep -v '^\.github'
FILES  := $(shell git ls-files $(IGNORE)) $(shell git ls-files --others $(IGNORE))
DIRS   := $(shell find $(FILES) -type f -exec dirname {} \; | grep -v '^\.$$' | sort -u)

all: 
	$(error "pick a target")

.PHONY: host

host:
	cp Makefile host/Makefile
	cd host && make install

install: dirs files

files:
	@for file in $(FILES) ; do \
		ln -sf $(PWD)/$$file $(HOME)/$$file ; \
	done

dirs:
	@for dir in $(DIRS) ; do \
		mkdir -p $(HOME)/$$dir ; \
	done
