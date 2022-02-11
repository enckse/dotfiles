TARGETS := bash kitty macports git vim tmux userdirs pipewire sway

.PHONY: $(TARGETS) machine

default:
	$(error please select a target to build)

machine:
	cd machine/$(shell uname -s | tr '[:upper:]' '[:lower:]') && stow --target $(HOME) .

setup:
	mkdir -p $(HOME)/.ssh
	mkdir -p $(HOME)/.vim

mac: common kitty macports

linux: common userdirs pipewire tmux sway

common: setup bash vim git machine

$(TARGETS):
	stow --target=$(HOME) $@
