#!/usr/bin/env zsh
autoload -Uz compinit && compinit
source "$HOME/.config/dotfiles/shell"
bindkey '\e[H' beginning-of-line
bindkey '\e[F' end-of-line

ssh_agent
load_comps

for CMD in git vim vi; do
    alias $CMD="echo $CMD disabled"
done
quickfix() {
    /usr/bin/vim --clean $@
}

command -v devcontainer > /dev/null && (devcontainer orphans >/dev/null 2>&1 &)

PS1="%{$(tput setaf 226)%}%n%{$(tput setaf 15)%}@%{$(tput setaf 200)%}%m %{$(tput setaf 45)%}%1~ %{$(tput sgr0)%}$ "
shell_ready
