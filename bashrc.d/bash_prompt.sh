#!/usr/bin/env bash

if [ -z ${__BASH_PROMPT__+x} ]
then
# First time this file is sourced
__BASH_PROMPT__="__BASH_PROMPT__"

# Actual script content
# ==============================================================================  

__BASH_PROMPT_SCRIPT_DIR__=$( cd -L $( dirname $(readlink -f "${BASH_SOURCE[0]}") ) && pwd  )

source $__BASH_PROMPT_SCRIPT_DIR__/bash_env_vars.sh
source $__BASH_PROMPT_SCRIPT_DIR__/git-prompt.sh
source $__BASH_PROMPT_SCRIPT_DIR__/bash_colors.sh

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

evalPromptDirPart(){
    local PROMPT_DIR_PART=`pwd`
    [[ $PROMPT_DIR_PART == $WS* ]] && PROMPT_DIR_PART=~/ws${PROMPT_DIR_PART#$WS}
    [[ $PROMPT_DIR_PART == $HOME* ]] && PROMPT_DIR_PART=~${PROMPT_DIR_PART#$HOME}
    printf $PROMPT_DIR_PART
}

unset color_prompt force_color_prompt

set_bash_prompt(){
    local LAST_CMD_EXIT_CODE="$?"
    local CMD_DEPENDENT_COLOR=
    if [[ $LAST_CMD_EXIT_CODE == 0 ]]
    then
	CMD_DEPENDENT_COLOR="$BIGreen"
    else
	CMD_DEPENDENT_COLOR="$BIRed"
    fi
    PS1="${debian_chroot:+($debian_chroot)}\[${CMD_DEPENDENT_COLOR}\]\t\[\033[00m\]:\[${Blue}\]$(evalPromptDirPart)\[\e[1;35m\]\$(__git_ps1)\[\033[00m\]\$ "
}

PROMPT_COMMAND=set_bash_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac



# ==============================================================================  
# End of actual script

fi # __BASH_PROMPT__
