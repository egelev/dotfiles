#!/usr/bin/env bash

if [ -z ${__BASH_ALIASES__+x} ]
then
# First time this file is sourced
__BASH_ALIASES__="__BASH_ALIASES__"

# Actual script content
# ==============================================================================

# See /usr/share/doc/bash-doc/examples in the bash-doc package.

__BASH_ALIASES_SCRIPT_DIR__=$( cd -L $( dirname $(readlink -f "${BASH_SOURCE[0]}") ) && pwd  )

# Bash aliases

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# ==============================================================================
# End of actual script

fi # __BASH_ALIASES__
