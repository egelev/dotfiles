#!/usr/bin/env bash

if [ -z ${__BASH_PROMPT__+x} ]
then
# First time this file is sourced
__BASH_PROMPT__="__BASH_PROMPT__"

# Actual script content
# ==============================================================================

__BASH_PROMPT_SCRIPT_DIR__=$( cd -L $( dirname $(readlink -f "${BASH_SOURCE[0]}") ) && pwd  )

source ${__BASH_PROMPT_SCRIPT_DIR__}/bash_colors.sh
source ${__BASH_PROMPT_SCRIPT_DIR__}/bash_env_vars.sh
source ${__BASH_PROMPT_SCRIPT_DIR__}/git-prompt.sh


getSshConnectionPrefix() {
    if [[ -n ${SSH_CONNECTION} ]]
    then
	local LOCAL_IP=$(echo ${SSH_CONNECTION} | tr -s ' ' | cut -d' ' -f 3)
	echo "(\[${IWhite}\]${LOCAL_IP})"
    fi
}

getChrootPromptPrefix() {
    # set variable identifying the chroot you work in (used in the prompt below)
    if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
	debian_chroot=$(cat /etc/debian_chroot)
    fi
    echo "${debian_chroot:+($debian_chroot)}"
}

getDirectoryToken(){
    local PROMPT_DIR_PART=`pwd`
    [[ ${PROMPT_DIR_PART} == ${WS}* ]] && PROMPT_DIR_PART=~/ws${PROMPT_DIR_PART#$WS}
    [[ ${PROMPT_DIR_PART} == ${HOME}* ]] && PROMPT_DIR_PART=~${PROMPT_DIR_PART#$HOME}
    printf ${PROMPT_DIR_PART}
}

getStatusColouredToken() {
    echo "\[${CMD_DEPENDENT_COLOR}\]"
}

getPromptSuffixSymbol() {
    echo "\$"
}

getVirtualEnvName() {
    if [ ! -z ${VIRTUAL_ENV+x} ]
    then
	echo "|$(basename ${VIRTUAL_ENV})"
    fi
}

appendSuffixSymbolToPrompt() {
    PS1="${PS1}\[${White}\]$(getPromptSuffixSymbol)"
}

appendSpaceToPrompt() {
    PS1="${PS1} "
}

defaultBashPrompt(){
        result=
	for token in $(getSshConnectionPrefix) $(getChrootPromptPrefix) "$(getStatusColouredToken)\t" "\[${White}\]:" "\[${Blue}\]$(getDirectoryToken)" "\[${BPurple}\]\$(__git_ps1)" "\[${Cyan}\]$(getVirtualEnvName)"
	do
	    result="${result}${token}"

	done
	echo "${result}"
}


# Overridable
getBashPromptColorOnSuccess() {
    echo "${BIGreen}"
}

# Overridable
getBashPromptColorOnFailure() {
    echo "${BIRed}"
}

# Overridable
setBashPrompt() {
    PS1="$(defaultBashPrompt)"
    appendSuffixSymbolToPrompt
    appendSpaceToPrompt
}

_getBashPromptColorDependingOnExitStatus() {
    local LAST_CMD_EXIT_CODE="$?"
    if [[ ${LAST_CMD_EXIT_CODE} == 0 ]]
    then
	echo $(getBashPromptColorOnSuccess)
    else
	echo $(getBashPromptColorOnFailure)
    fi
}

__bashColorifiedPromptFunction() {
    # Export the cmd dependent color to the overridable function
    export CMD_DEPENDENT_COLOR=$(_getBashPromptColorDependingOnExitStatus)
    setBashPrompt
}

PROMPT_COMMAND=__bashColorifiedPromptFunction


# ==============================================================================
# End of actual script

fi # __BASH_PROMPT__
