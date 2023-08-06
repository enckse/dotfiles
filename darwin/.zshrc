export PATH="$HOME/.bin:$PATH"
export CLICOLOR=1

zstyle ':completion:*:*:git:*' user-commands uncommitted:'check for uncommitted changes' 
autoload -Uz compinit && compinit
COMPLETIONS="$HOME/.completions"
LB_COMP="$COMPLETIONS/lb"
if [ ! -d "$COMPLETIONS" ]; then
  mkdir -p "$COMPLETIONS"
fi
if [ -x "$HOME/.bin/lb" ]; then
  if [ ! -s "$LB_COMP" ]; then
    lb zsh > "$LB_COMP" 
  fi
fi
if [ -s "$LB_COMP" ]; then
  source "$LB_COMP"
  compdef _lb lb
fi

CONFD="$HOME/.zshrc.d"
if [ -d "$CONFD" ]; then
    source "$CONFD/"*
fi
unset COMPLETIONS LB_COMP CONFD

git uncommitted
