alias clip="xclip -selection 'clip-board'"
alias diff="diff -u"
alias ls='ls --color=auto'
alias ossh="/usr/bin/ossh -F /dev/null"
alias dd="sudo dd status=progress"
alias gmail="/home/enck/.local/bin/email client gmail"
alias fastmail="/home/enck/.local/bin/email client fastmail"
alias mutt="echo 'disabled in bash'"
alias vlc="echo 'disable in bash'"

notes() {
    source $HOME/.config/home/common
    local file files f
    file="$@"
    if [ -z "$file" ]; then
        file=scratch
    fi
    for f in $(echo "$file"); do
        files="$files ${HOME_SCRATCH}$f$TASK_FILE"
    done
    vim $files
}

grubluks() {
    echo "configfile (hd0,1)/grub/grub.cfg" | clip
    echo "command in clipboard"
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
