#!/bin/bash
# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

export NOTIFY_MESSAGES="$HOME/.cache/messages"
if [ ! -d "$NOTIFY_MESSAGES" ]; then
    mkdir -p $NOTIFY_MESSAGES
fi
