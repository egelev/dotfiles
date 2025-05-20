#!/usr/bin/env bash

if [ -z ${__BASH_FUNCTIONS__+x} ]
then
# First time this file is sourced
__BASH_FUNCTIONS__="__BASH_FUNCTIONS__"

# Actual script content
# ==============================================================================

__BASH_FUNCTIONS_SCRIPT_DIR__=$( cd -L "$( dirname "$(readlink -f "${BASH_SOURCE[0]}")" )" && pwd  
source ${__BASH_FUNCTIONS_SCRIPT_DIR__}/bash_env_vars.sh
source ${__BASH_FUNCTIONS_SCRIPT_DIR__}/git-prompt.sh

function rpm_unpack() {
    rpm2cpio $1 | cpio -idmv
}

function gAmend() {
    git add -u
    git commit --amend --no-edit
    git log -n 1 | head -1 | awk {'print $2'}
}

function gSubmoduleRemove() {
   local path=${1}
   # Remove the submodule entry from .git/config
   git submodule deinit -f ${path}

   # Remove the submodule directory from the superproject's .git/modules directory
   rm -rf .git/modules/${path}

   # Remove the entry in .gitmodules and remove the submodule directory located at path/to/submodule
   git rm -f ${path}
}

function getAbsPath() {
    local fileRelPath=$1
    local dirNameAbsPath="$( cd "$( dirname "${fileRelPath}"  )" && pwd  )"
    local fileName="$(basename ${fileRelPath})"
    echo "${dirNameAbsPath}/${fileName}"
}

function dockerRemoveDanglingVolumes() {
    for v in $(docker volume ls -f dangling=true | tr -s ' ' | cut -d' ' -f2 | tail -n+2)
    do
      echo "deleting volume: ${v}"
      docker volume rm ${v}
    done
}

function dockerRemoveUnknownImages() {
    for img in $(docker images --filter "dangling=true" --quiet)
    do
	echo "deleting image: ${img}"
	docker rmi ${img};
    done
}


function parseUrl() {
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

function getProperty() {
    local fileName=$1
    local propertiyPatterns="${@:2}"

    for prop in ${propertiyPatterns}
    do
       p=${prop//\./\\.}
       grep "${p}" ${fileName} | sed -n -e "s/^[[:space:]]*${p}[[:space:]]*[=:][[:space:]]*\(.*\)$/\1/p"
    done
}

function dockerRemoveByTag() {
    local tag=$1
    if [ -z "${tag}" ]
    then
        echo "Usage dockerRemoveByTag <tag>"
        return 1
    fi

    for name in $(docker image ls | grep ${tag} | tr -s ' ' | cut -d ' ' -f 1)
    do
        docker image rm ${name}:${tag}
    done
}

function getPIDbyPort() {
   local port=$1
   netstat -tuplen 2>/dev/null  | grep "${port}" | tr -s ' ' | cut -d' ' -f 9 | sed  -e "s/\([[:digit:]]*\)\/.*/\1/g"
}

function getWordCountOfFile() {
   local file=$1
   fmt -1 <${file}  | grep -E -o -i '[[:alnum:]]{3,}' | sort | uniq -ci | sort -nr
}

function testColours() {
        local T='gYw'   # The test text

        echo -e "\n                 40m     41m     42m     43m\
             44m     45m     46m     47m";

        for FGs in '    m' '   1m' '  30m' '1;30m' '  31m' '1;31m' '  32m' \
                   '1;32m' '  33m' '1;33m' '  34m' '1;34m' '  35m' '1;35m' \
                   '  36m' '1;36m' '  37m' '1;37m';
          do FG=${FGs// /}
          echo -en " $FGs \033[$FG  $T  "
          for BG in 40m 41m 42m 43m 44m 45m 46m 47m;
            do echo -en "$EINS \033[$FG\033[$BG  $T  \033[0m";
          done
          echo;
        done
        echo
}

function clearIdeaFiles() {
      # TODO
      # .idea
      # *.iws
      # *.iml
      # *.ipr
      local idea_dirs="$(find . -iname  "*.idea" -type d)"
      if [ -n "${idea_dirs}" ]
      then
         for d in ${idea_dirs}
         do
            echo "Deleting ${d}"
            rm -rf ${d}
         done
      fi

      local imls="$(find . -iname  "*.iml")"
      if [ -n "${imls}" ]
      then
         for f in ${imls}
         do
            echo "Deleting ${f}"
            rm -rf ${f}
         done
      fi
}

function randomPassword() {
   local length=${1:-32}
   echo $(cat /dev/urandom | tr -dc '[:alpha:]' | fold -w ${length} | head -n 1)
}

function download_file() {
    local url=${1}
    local targetFileName=${2}
    if [[ -d ${targetFileName} ]]
    then
	targetFileName="${targetFileName}/$(basename ${url})"
    fi

    local downloadedFile=$(mktemp "/tmp/$(basename ${targetFileName}).XXXXXX")
    echo ${downloadedFile}
    echo "Downloading ${url}"
    wget --quiet --show-progress --output-document=${downloadedFile} ${url}
    if [[ -e ${targetFileName} ]]
    then
	if (diff ${targetFileName} ${downloadedFile} 2>&1 1>/dev/null)
	then
	    # No diff
	    echo "The file on ${url} is the same as ${targetFileName}"
	    rm ${downloadedFile}
	    return 0
	else
	    # Diff - backup
	    echo "File ${targetFileName} already exists."
	    mv ${targetFileName} "${targetFileName}.bkp"
	    echo "Backup available at ${targetFileName}.bkp"
	fi
    fi
    mkdir -p $(dirname ${targetFileName})
    mv ${downloadedFile} ${targetFileName}
    echo "Downloaded to ${targetFileName}"
}

# ==============================================================================
# End of actual script

fi # __BASH_FUNCTIONS__
