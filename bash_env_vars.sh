#!/usr/bin/env bash

if [ -z ${__BASH_ENV_VARS__+x} ]
then
# First time this file is sourced
__BASH_ENV_VARS__="__BASH_ENV_VARS__"

# Actual script content
# ==============================================================================  

__BASH_ENV_VARS_SCRIPT_DIR__=$( cd -L $( dirname $(readlink -f "${BASH_SOURCE[0]}") ) && pwd  )

# User defined global environmetn variables
export DEV_DIR=$HOME/dev
export WS=$DEV_DIR/workspace

export JAVA_ROOT=$DEV_DIR/java
export JAVA_HOME=$JAVA_ROOT/jdk1.8.0_66
export J9=$JAVA_ROOT/jdk1.9.0

export M2_HOME=$DEV_DIR/apache-maven-3.3.3

export PATH=$JAVA_HOME/bin:$M2_HOME/bin:$HOME/bin:$PATH


# ==============================================================================  
# End of actual script

fi # __BASH_ENV_VARS__
