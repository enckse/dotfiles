alias clip="xclip -selection 'clip-board'"
alias diff="diff -u"
alias ls='ls --color=auto'
alias ossh="/usr/bin/ossh -F /dev/null"
alias dd="sudo dd status=progress"
alias gmail="/home/enck/.local/bin/email client gmail"
alias fastmail="/home/enck/.local/bin/email client fastmail"
alias dquilt="quilt --quiltrc=${HOME}/.config/quiltrc-dpkg"
alias duplicates="find . -type f -print0 | xargs -0 md5sum | sort | uniq -w32 --all-repeated=separate"
alias syncing="/home/enck/.local/bin/syncing run"

for f in zim vlc mutt virtualbox geany; do
    alias $f="echo 'disabled in bash'"
done

geany_project() {
    if [ -z "$1" ]; then
        echo "project required"
    else
        pgrep geany
        if [ $? -eq 0 ]; then
            /usr/bin/geany $1
        else
            echo "geany is not running..."
        fi
    fi
}

proxy() {
    if [ -z "$1" ]; then
        echo "host required"
    else
        ssh -D 1234 -N $1
    fi
}

ssh() {
    TERM=xterm /usr/bin/ssh "$@" || return
}

clear-journal() {
    source $HOME/.local/bin/conf
    rm -f $JOURNALS
}

hpcssh() {
    local cwd=$PWD
    cd ${PERM_APPS}hpcssh
    ./connect $@
    cd $cwd
}
