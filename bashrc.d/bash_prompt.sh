#!/usr/bin/env bash

if [ -z ${__BASH_PROMPT__+x} ]
then
# First time this file is sourced
__BASH_PROMPT__="__BASH_PROMPT__"

# Actual script content
# ==============================================================================

__BASH_PROMPT_SCRIPT_DIR__=$( cd -L "$( dirname "$(readlink -f "${BASH_SOURCE[0]}")" )" && pwd  )

source ${__BASH_PROMPT_SCRIPT_DIR__}/bash_colors.sh
source ${__BASH_PROMPT_SCRIPT_DIR__}/bash_env_vars.sh
source ${__BASH_PROMPT_SCRIPT_DIR__}/git-prompt.sh


function getSshConnectionPrefix() {
    if [[ -n ${SSH_CONNECTION} ]]
    then
	local LOCAL_IP=$(echo ${SSH_CONNECTION} | tr -s ' ' | cut -d' ' -f 3)
	echo "(\[${IWhite}\]${LOCAL_IP})"
    fi
}

function getChrootPromptPrefix() {
    # set variable identifying the chroot you work in (used in the prompt below)
    if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
    fi
    echo "${debian_chroot:+($debian_chroot)}"
}

function replacePathPrefix() {
    local path=${1}
    local prefix=${2}
    local replacement=${3}

    [[ ${path} == ${prefix}* ]] && path=${replacement}${path#$prefix}
    local expanded_prefix=$(readlink -f ${prefix})
    [[ ${path} == ${expanded_prefix}* ]] && path=${replacement}${path#$expanded_prefix}
    printf ${path}
}

function getDirectoryToken(){
    local PROMPT_DIR_PART=`pwd`
    PROMPT_DIR_PART=$(replacePathPrefix ${PROMPT_DIR_PART} ${WS} "~/ws")
    PROMPT_DIR_PART=$(replacePathPrefix ${PROMPT_DIR_PART} ${HOME} "~")
    printf ${PROMPT_DIR_PART}
}

function getStatusColouredToken() {
    echo "\[${CMD_DEPENDENT_COLOR}\]"
}

function getPromptSuffixSymbol() {
    echo "\$"
}

# Overridable
function getVirtualEnvName() {
    if [ ! -z ${VIRTUAL_ENV+x} ]
    then
	echo "|$(basename ${VIRTUAL_ENV})"
    fi
}

function appendSuffixSymbolToPrompt() {
    PS1="${PS1}\[${White}\]$(getPromptSuffixSymbol)"
}

function appendSpaceToPrompt() {
    PS1="${PS1} "
}

function defaultBashPrompt(){
        result=
	for token in $(getSshConnectionPrefix) $(getChrootPromptPrefix) "$(getStatusColouredToken)\t" "\[${White}\]:" "\[${Blue}\]$(getDirectoryToken)" "\[${BPurple}\]\$(__git_ps1)" "\[${Cyan}\]$(getVirtualEnvName)"
	do
	    result="${result}${token}"

	done
	echo "${result}"
}


# Overridable
function getBashPromptColorOnSuccess() {
    echo "${BIGreen}"
}

# Overridable
function getBashPromptColorOnFailure() {
    echo "${BIRed}"
}

# Overridable
function setBashPrompt() {
    PS1="$(defaultBashPrompt)"
    appendSuffixSymbolToPrompt
    appendSpaceToPrompt
}

function _getBashPromptColorDependingOnExitStatus() {
    local LAST_CMD_EXIT_CODE="$?"
    if [[ ${LAST_CMD_EXIT_CODE} == 0 ]]
    then
	echo $(getBashPromptColorOnSuccess)
    else
	echo $(getBashPromptColorOnFailure)
    fi
}

function __bashColorifiedPromptFunction() {
    # Export the cmd dependent color to the overridable function
    export CMD_DEPENDENT_COLOR=$(_getBashPromptColorDependingOnExitStatus)
    setBashPrompt
}

if ((BASH_VERSINFO[0] > 5 || BASH_VERSINFO[0] == 5 && BASH_VERSINFO[1] >= 1))
then
    PROMPT_COMMAND=(__bashColorifiedPromptFunction)
else
    PROMPT_COMMAND=__bashColorifiedPromptFunction
fi



# ==============================================================================
# End of actual script

fi # __BASH_PROMPT__
