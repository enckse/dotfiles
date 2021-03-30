eval "$(/opt/homebrew/bin/brew shellenv)"
source ~/.completions/zshrc

_motd() {
    devtools=~/.bin/built
    echo "==================================================================="
    echo
    git -C ~ log -n1 --format="%cd (%h)" | sed 's/^/    home:     /g'
    if [ -e $devtools ]; then
        cat $devtools | sed 's/^/    devtools: /g'
    fi
    echo
    echo "==================================================================="
    echo
}


gpga
export GPG_TTY=$(tty)

_vimsetup() {
    airline=~/.vim/pack/dist/start/vim-airline
    if [ ! -d $airline ]; then
        git clone https://github.com/vim-airline/vim-airline $airline
    fi
    tmp=~/.vim/tmp
    if [ ! -d $tmp ]; then
        mkdir -p $tmp
    fi
    tmpfile=$tmp/$(date +%Y%m%d)
    if [ ! -e $tmpfile ]; then
        for o in swap tmp undo; do
            find ~/.vim/$o -type f -mtime +1 -delete
        done
        touch $tmpfile
    fi
}

_diffhighlight() {
    ln -sf $(find /opt/homebrew/Cellar/git -type f -name "diff-highlight" | sort -r | head -n 1) ~/.bin/diff-highlight
}

brew() {
    cfg=~/.config/voidedtech
    /opt/homebrew/bin/brew $@
    rm -f $cfg/Brewfile
    cwd=$PWD
    cd $cfg && /opt/homebrew/bin/brew bundle dump
    cd $cwd
}

_motd
_diffhighlight
_vimsetup

source ~/Git/personal/zshrc
alias history="cat $HOME/.zsh_history"
