#!/usr/bin/env bash

__SETUP_SCRIPT_DIR__=$( cd -L $( dirname $(readlink -f "${BASH_SOURCE[0]}") ) && pwd  )

__DOTFILES_DIR__=$(readlink -f ${__SETUP_SCRIPT_DIR__})

__BASHRC_DIR__=${__DOTFILES_DIR__}/bashrc.d

function replace_file() {

    local original_file=$1
    local new_file=$2
    local bkp_file=$3

    if [[ "$(readlink ${original_file})" == "${new_file}" ]]
    then
	echo "${original_file} is already replaced with ${new_file}"
	return 0
    fi

    if [[ -e ${bkp_file} ]]
    then
	echo "Error: Backup file is already present"
	exit 1
    else
	if [[ -e ${original_file} ]]
	then
	    mkdir -p $(dirname ${bkp_file})
	    mv ${original_file} ${bkp_file}
	    echo "${original_file} has been backed up to ${bkp_file}"
	fi
	ln -s ${new_file} ${original_file}
	echo "Success replacing ${original_file} --> ${new_file}. Backup available at ${bkp_file}"
    fi
}

function backup_local_dotfiles() {

    BASHRC=${HOME}/.bashrc
    NEW_BASHRC=${__DOTFILES_DIR__}/bashrc
    BKP_BASHRC=${HOME}/.bashrc.d/50-bashrc.sh
    replace_file ${BASHRC} ${NEW_BASHRC} ${BKP_BASHRC}
    echo "Put all your local bashrc configuration files in '$(dirname ${BKP_BASHRC})'. They will get loaded automatically in alphabetical order."

    VIM_DIR=${HOME}/.vim
    NEW_VIM_DIR=${__DOTFILES_DIR__}/vim
    BKP_VIM_DIR=${HOME}/.vim_bkp_dir
    replace_file ${VIM_DIR} ${NEW_VIM_DIR} ${BKP_VIM_DIR}

    VIMRC=${HOME}/.vimrc
    NEW_VIMRC=${NEW_VIM_DIR}/vimrc
    BKP_VIMRC=${HOME}/.vimrc_bkp_file
    replace_file ${VIMRC} ${NEW_VIMRC} ${BKP_VIMRC}
}

function get_well_known_dirs_definitions() {
    cat ${__BASHRC_DIR__}/bash_env_vars.sh | sed -n '/__WELL_KNOWN_DIRS_DEFINITION_BEGINS__/,/__WELL_KNOWN_DIRS_DEFINITION_ENDS__/p' | grep 'export' | sed -n 's/^[[:space:]]*export[[:space:]]*\([_[:alnum:]]\+\)[[:space:]]*=.*$/\1/p'
}

function ensure_all_well_known_dirs() {
    source ${__BASHRC_DIR__}/bash_env_vars.sh
    for dir in $(get_well_known_dirs_definitions)
    do
	local expanded_dir=$(eval "echo \$${dir}")
	if [[ ! -d ${expanded_dir} ]]
	then
	    mkdir -p ${expanded_dir}
	    echo "Directory tree ${expanded_dir} initialized."
	fi
    done
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

function download_additional_scripts() {
    local list="
	https://gist.githubusercontent.com/egelev/2e6b57d5a8ba62cf6df6fff2878c3fd4/raw/c4852f7703dbc71779adab088f0f7ae7cd7184b3/connect_bluetooth_headphones.sh
    "
    for url in ${list}
    do
	download_file ${url} ${HOME}/bin
    done
}

function main() {
    backup_local_dotfiles
    ensure_all_well_known_dirs
}

main
