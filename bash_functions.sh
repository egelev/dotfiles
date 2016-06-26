#!/usr/bin/env bash

if [ -z ${__BASH_FUNCTIONS__+x} ]
then
# First time this file is sourced
__BASH_FUNCTIONS__="__BASH_FUNCTIONS__"

# Actual script content
# ==============================================================================

__BASH_FUNCTIONS_SCRIPT_DIR__=$( cd -L $( dirname $(readlink -f "${BASH_SOURCE[0]}") ) && pwd  )

source $__BASH_FUNCTIONS_SCRIPT_DIR__/bash_env_vars.sh
source $__BASH_FUNCTIONS_SCRIPT_DIR__/git-prompt.sh

rpm_unpack() {
    rpm2cpio $1 | cpio -idmv
}

git_top(){
    echo $(git log -n 1 | head -1 | cut -d' ' -f2)
}

gAmend() {
    git add -u
    git commit --amend --no-edit
    git log -n 1 | head -1 | awk {'print $2'}
}

gUpdateSubmodules() {
    # Ref: http://stackoverflow.com/a/18799234/1760058
    git submodule foreach -q --recursive 'git checkout $(git config -f $toplevel/.gitmodules submodule.$name.branch || echo master)'
}
# ==============================================================================
# End of actual script

fi # __BASH_FUNCTIONS__
