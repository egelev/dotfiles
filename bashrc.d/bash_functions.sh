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
    for img in $(docker images --filter "dangling=true" --quiet)
    do
	echo "deleting image: $img"
	docker rmi $img;
    done
}


parseUrl() {
   local url=$1
   local parse_request=$2

   local optional="\?"
   local protocol="\([.[:alnum:]+-]\+:[\/]\+\)" # 1
   local hostname="\([[:alnum:].-]*\)" # 2
   local port="\(:[[:digit:]]*\)" # 3
   local path="\(\/[^?]*\)" # 4
   local query="\(?[^#]*\)" # 5
   local fragment="\(#.*\)" # 6
   local regex="${protocol}${optional}${hostname}${port}${optional}${path}${optional}${query}${optional}${fragment}${optional}"

   case ${parse_request} in
      "protocol")
         echo $(echo "${url}" | sed -n -e "s/^${regex}$/\1/p")
         ;;
      "hostname")
         echo $(echo "${url}" | sed -n -e "s/^${regex}$/\2/p")
         ;;
      "port")
         echo $(echo "${url}" | sed -n -e "s/^${regex}$/\3/p" | tr -d ':')
         ;;
      "path")
         path=$(echo "${url}" | sed -n -e "s/^${regex}$/\4/p")
         echo ${path#/}
         ;;
      "query")
         query=$(echo "${url}" | sed -n -e "s/^${regex}$/\5/p")
         echo ${query#?}
         ;;
      "fragment")
         fragment=$(echo "${url}" | sed -n -e "s/^${regex}$/\6/p")
         echo ${fragment#\#}
         ;;
   esac
}

# ==============================================================================
# End of actual script

fi # __BASH_FUNCTIONS__
