# If not running interactively, don't do anything
# FIX for incoming scp.
[ -z "$PS1" ] && return

source "$HOME/.secrets.sh"

# Sane defaults
export EDITOR=/usr/bin/vim
export PATH="$HOME/bin:$PATH"


#------------------------------------------------------------------------------#
# Initialize GPG

# https://rnorth.org/gpg-and-ssh-with-yubikey-for-mac
# Start or re-use a gpg-agent.
gpgconf --launch gpg-agent

if [ -f "${HOME}/.gpg-agent-info" ]; then
  source  "${HOME}/.gpg-agent-info"
  export GPG_AGENT_INFO
  export SSH_AUTH_SOCK
fi
export GPG_TTY=$(tty)

export PATH=/opt/ykpers-1.17.3-mac/bin:$PATH


#------------------------------------------------------------------------------#
# Give me a smart editor
VIM=/usr/bin/vim
NVIM=/usr/local/bin/nvim
export EDITOR=$VIM

if [ -f "$NVIM" ]; then
    export EDITOR=$NVIM
    alias vim="$NVIM"
    alias ovim="$VIM"
fi

#------------------------------------------------------------------------------#
# Neomutt is mutt
alias mutt=$(which neomutt)
export PATH="/usr/local/opt/python/libexec/bin:$PATH"

#------------------------------------------------------------------------------#
# BASH HISTORY
# ignore duplicate cmd and command starting with ' '
export HISTCONTROL=ignoreboth
# append instead of rewrite (should be cool with multiple instances"
shopt -s histappend
# ignore the following commands
HISTIGNORE='ls:bg:fg:history'
# Record timestamps
HISTTIMEFORMAT='%F %T '
# Use one command per line
shopt -s cmdhist
# Store history immediately
PROMPT_COMMAND='history -a'


#------------------------------------------------------------------------------#
# Shortcuts - DRY
alias mkdir='mkdir -p'
alias ls='ls -hG'
alias ll='ls -alh --color'
alias du='du -kh'           # Makes a more readable output.
alias df='df -kTh'
alias dsize='du -sh'        # directory 'size'

#------------------------------------------------------------------------------#
# HOMEBREW
export HOMEBREW_MAKE_JOBS=4
export PATH="/usr/local/bin:/usr/local/sbin:$PATH"

#------------------------------------------------------------------------------#
# Brew Applications fixes & shortcuts

#> GO
export GOPATH=$HOME/go                             # defaults
export PATH=$GOPATH/bin:$PATH

#> LaTeX
export PATH=$PATH:/usr/texbin

#> Virt-Manger
# virt-manager -c qemu+ssh://user@libvirthost/system?socket=/var/run/libvirt/libvirt-sock
# virt-viewer -c qemu+ssh://user@libvirthost/system?socket=/var/run/libvirt/libvirt-sock
function virt {
    virt-manager \
        -c qemu+ssh://$1/system?socket=/var/run/libvirt/libvirt-sock \
        --debug --no-fork
}


alias python="python -t"


#------------------------------------------------------------------------------#
# Helpers

function dav_to_mp4 {
    # Useful to convert security cam video extracted from SmartPSS
    ffmpeg -i "${1}" -vcodec libx264 -crf 18 "${1}.mp4"
}


function who_listen {
    # Listen running service
    lsof -n -i4TCP:$1 | grep LISTEN
}

function compress {
    for fname in "$@"; do
        echo "$fname"
        org="${fname%.*}.org.${fname##*.}"
        mv "$fname" "$org"
        convert "$org" pnm:- | cjpeg -optimize -progressive -quality 90 > "${fname%.*}.jpg"
    done
}

function weather {
    curl http://wttr.in/Trento
}


#------------------------------------------------------------------------------#
# PS1 style

function existsOrDownload {
    if [ ! -f "$1" ]; then
        echo "download $1"
        curl -s -o "$1" "$2"
    fi
}

function prompt {
    # Support for Git
    existsOrDownload "$HOME/.git-completion.bash" \
        "https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash"
    source $HOME/.git-completion.bash

    existsOrDownload "$HOME/.git-prompt.bash" \
        "https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh"
    source $HOME/.git-prompt.bash

    # Support for virtual-env
    function virtualenv_info(){
        # Get Virtual Env
        if [[ -n "$VIRTUAL_ENV" ]]; then
            # Strip out the path and just leave the env name
            venv="${VIRTUAL_ENV##*/}"
        else
            # In case you don't have one activated
            venv=''
        fi
        [[ -n "$venv" ]] && echo "<$venv>"
    }

    # disable the default virtualenv prompt change
    export VIRTUAL_ENV_DISABLE_PROMPT=1

    local VENV="\$(virtualenv_info)";

    # 30m - Black
    # 31m - Red
    # 32m - Green
    # 33m - Yellow
    # 34m - Blue
    # 35m - Purple
    # 36m - Cyan
    # 37m - White
    # 0 - Normal
    # 1 - Bold
    local RESET="\[$(tput sgr0)\]"

    local BLACK="\[\033[0;30m\]"
    local BLACKBOLD="\[\033[1;30m\]"
    local RED="\[\033[0;31m\]"
    local REDBOLD="\[\033[1;31m\]"
    local GREEN="\[\033[0;32m\]"
    local GREENBOLD="\[\033[1;32m\]"
    local YELLOW="\[\033[0;33m\]"
    local YELLOWBOLD="\[\033[1;33m\]"
    local BLUE="\[\033[0;34m\]"
    local BLUEBOLD="\[\033[1;34m\]"
    local PURPLE="\[\033[0;35m\]"
    local PURPLEBOLD="\[\033[1;35m\]"
    local CYAN="\[\033[0;36m\]"
    local CYANBOLD="\[\033[1;36m\]"
    local WHITE="\[\033[0;37m\]"
    local WHITEBOLD="\[\033[1;37m\]"
#    local LAMBDA=$'\u03BB'
    local LAMBDA='λ'

    # Do not indent (space metters)
    # Dark theme
    export PS1="$WHITEBOLD\[\e(0\]l\[\e(B\] $YELLOW\@$WHITEBOLD \
$WHITE[$RED\u$WHITE@$GREEN\h$WHITE]\$(__git_ps1) ${VENV} $CYAN\w\n\
$WHITEBOLD\[\e(0\]m\[\e(B\]$WHITEBOLD $LAMBDA $RESET"

    # White theme
#    export PS1="$BLACKBOLD\[\e(0\]l\[\e(B\] $YELLOW\@$BLACKBOLD \
#$BLACK[$RED\u$BLACK@$GREEN\h$BLACK]\$(__git_ps1) ${VENV} $CYAN\w\n\
#$BLACKBOLD\[\e(0\]m\[\e(B\]$BLACKBOLD $LAMBDA $RESET"
}
prompt


# Import from OSX /etc/bashrc
# fixes: new tab same working directory
shopt -s checkwinsize
[[ -r "/etc/bashrc_$TERM_PROGRAM" ]] && . "/etc/bashrc_$TERM_PROGRAM"
