# If not running interactively, don't do anything
# FIX for incoming scp.
[ -z "$PS1" ] && return

source "$HOME/.secrets.sh"

# Fix locale on OSX
export LC_ALL=en_US.UTF-8
export LANG=en_IT.UTF-8

# Sane defaults
export EDITOR=/usr/bin/vim
export PATH="$HOME/bin:$PATH"

function wiki_commit() { cd $HOME/vimwiki/ && git add . && (git commit -S -m "$(date)" || git commit -m "$(date)" ) && git push; }


#------------------------------------------------------------------------------#
# Initialize GPG
# Enable gpg-agent if it is not running
# TODO: test linux config
platform=$(uname)
GPG_AGENT_SOCKET="${XDG_RUNTIME_DIR}/gnupg/S.gpg-agent.ssh"  # On linux
if [[ "$platform" == 'Darwin' ]]; then # On macos
    GPG_AGENT_SOCKET="$HOME/.gnupg/S.gpg-agent.ssh"
fi

if [ ! -S "$GPG_AGENT_SOCKET" ]; then
  gpg-agent --daemon >/dev/null 2>&1
  GPG_TTY=$(tty)
  export GPG_TTY
fi

# Set SSH to use gpg-agent if it is configured to do so
GNUPGCONFIG=${GNUPGHOME:-"$HOME/.gnupg/gpg-agent.conf"}
if grep -q enable-ssh-support "$GNUPGCONFIG"; then
  unset SSH_AGENT_PID
  export SSH_AUTH_SOCK=$GPG_AGENT_SOCKET
fi

if [[ "$platform" == 'Darwin' ]]; then # On macos
    # https://stuff-things.net/2016/02/11/stupid-ssh-add-tricks/
    # Must use -K and osx ssh binary
    alias ssh_rm_id="/usr/bin/ssh-add -K -d"
fi


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

alias wiki="vim -c VimwikiIndex"
alias todo="wiki"
alias note="wiki"

#------------------------------------------------------------------------------#
# Neomutt is mutt
alias mutt="$(command -v neomutt)"
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
alias ll='ls -alhG'
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

# USE GO MODULES !!!!
export GO111MODULE=on

#> Ruby
export PATH="/usr/local/opt/ruby/bin:$PATH"
gem_v=$(ls /usr/local/lib/ruby/gems/ | sort -V -r | head -n1)
export PATH="/usr/local/lib/ruby/gems/$gem_v/bin:$PATH"
export PATH="/Users/martin/.gem/ruby/$gem_v/bin:$PATH"


#> LaTeX
export PATH=$PATH:/usr/texbin

#> Virt-Manger
# virt-manager -c qemu+ssh://user@libvirthost/system?socket=/var/run/libvirt/libvirt-sock
# virt-viewer -c qemu+ssh://user@libvirthost/system?socket=/var/run/libvirt/libvirt-sock
function virt {
    virt-manager \
        -c "qemu+ssh://$1/system?socket=/var/run/libvirt/libvirt-sock" \
        --debug --no-fork
}

#> Postgresql.app
export PATH="/Applications/Postgres.app/Contents/Versions/10/bin/:$PATH"


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
export PATH="/usr/local/opt/openssl/bin:$PATH"
