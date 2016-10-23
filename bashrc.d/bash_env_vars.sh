#!/usr/bin/env bash

if [ -z ${__BASH_ENV_VARS__+x} ]
then
# First time this file is sourced
__BASH_ENV_VARS__="__BASH_ENV_VARS__"

# Actual script content
# ==============================================================================

__BASH_ENV_VARS_SCRIPT_DIR__=$( cd -L $( dirname $(readlink -f "${BASH_SOURCE[0]}") ) && pwd  )

# User defined global environmetn variables

# __WELL_KNOWN_DIRS_DEFINITION_BEGINS__

export DEV_DIR=$HOME/dev
export WS=$DEV_DIR/workspaces
export TOOLS=$DEV_DIR/tools
export JAVA_ROOT=$TOOLS/java

# __WELL_KNOWN_DIRS_DEFINITION_ENDS__

export PATH=$HOME/bin:$PATH

# Default vim daylight interval
export VIM_DAYLIGHT_START="8:00"
export VIM_DAYLIGHT_END="18:00"

# ==============================================================================
# End of actual script

fi # __BASH_ENV_VARS__
