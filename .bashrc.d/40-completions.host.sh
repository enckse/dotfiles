#!/usr/bin/env bash
_enter-toolbox() {
    local cur opts
    if [ "$COMP_CWORD" -eq 1 ]; then
        cur=${COMP_WORDS[COMP_CWORD]}
        opts=$(enter-toolbox --list)
        if [ -n "$opts" ]; then
            opts="$opts --update"
        fi
        COMPREPLY=( $(compgen -W "$opts" -- "$cur") )
    fi
}

complete -F _enter-toolbox -o bashdefault -o default enter-toolbox
