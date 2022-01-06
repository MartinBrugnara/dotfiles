# If not running interactively, don't do anything
# FIX for incoming scp.
[ -z "$PS1" ] && return

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
# Source my env
if [ -f "$HOME/.mb_init" ]; then
    source "$HOME/.mb_init"
fi

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

# https://www.vidarholen.net/contents/blog/?p=878
PROMPT_COMMAND='printf "⏎%$((COLUMNS-1))s\\r"'

# Import from OSX /etc/bashrc
# fixes: new tab same working directory
shopt -s checkwinsize
[[ -r "/etc/bashrc_$TERM_PROGRAM" ]] && . "/etc/bashrc_$TERM_PROGRAM"
