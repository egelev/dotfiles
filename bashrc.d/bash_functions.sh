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

getAbsPath() {
    local fileRelPath=$1
    local dirNameAbsPath="$( cd "$( dirname "$fileRelPath"  )" && pwd  )"
    local fileName="$(basename $fileRelPath)"
    echo "$dirNameAbsPath/$fileName"
}

dockerRemoveDanglingVolumes() {
    for v in $(docker volume ls -f dangling=true | tr -s ' ' | cut -d' ' -f2 | tail -n+2)
    do
      echo "deleting volume: $v"
      docker volume rm $v
    done
}

dockerRemoveUnknownImages() {
    for img in $(docker images | grep "<none>" | tr -s ' ' | cut -d ' ' -f 3 | sort -u)
    do
	echo "deleting image: $img"
	docker rmi $img;
    done
}

# ==============================================================================
# End of actual script

fi # __BASH_FUNCTIONS__
