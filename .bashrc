#!/usr/bin/env bash
[[ $- != *i* ]] && return

HISTCONTROL=ignoreboth:erasedups

shopt -s histappend
shopt -s direxpand

HISTSIZE=-1
HISTFILESIZE=-1

export VISUAL=vi
export EDITOR="$VISUAL"
export LESSHISTFILE=$HOME/.cache/lesshst
export COMP_KNOWN_HOSTS_WITH_HOSTFILE=""

for file in $HOME/.bash_aliases; do
    if [ -e "$file" ]; then
        . "$file"
    fi
done
for file in $HOME/.config/bash/*; do
    if [ -e "$file" ]; then
        . "$file"
    fi
done

unset file
export TERM=xterm-256color
PREFERPS1="(\u@\h \W)"
if [ -z "$SSH_CONNECTION" ]; then
    PS1=$PREFERPS1'$ '
else
    PS1='\[\033[01;33m\]'$PREFERPS1'\[\033[0m\]> '
fi

# check the window size after each command
shopt -s checkwinsize
