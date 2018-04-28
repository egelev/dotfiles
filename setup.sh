#!/usr/bin/env bash

__SETUP_SCRIPT_DIR__=$( cd -L $( dirname $(readlink -f "${BASH_SOURCE[0]}") ) && pwd  )

__DOTFILES_DIR__=$(readlink -f $__SETUP_SCRIPT_DIR__)

__BASHRC_DIR__=$__DOTFILES_DIR__/bashrc.d

source ${__BASHRC_DIR__}/bash_env_vars.sh

replace_file() {

    local original_file=$1
    local new_file=$2
    local bkp_file=$3

    if [[ "$(readlink $original_file)" == "$new_file" ]]
    then
	echo "$original_file is already replaced with $new_file"
	return 0
    fi

    if [[ -e $bkp_file ]]
    then
	echo "Error: Backup file is already present"
	exit 1
    else
	if [[ -e $original_file ]]
	then
	    mkdir -p $(dirname $bkp_file)
	    mv $original_file $bkp_file
	    echo "$original_file has been backed up to $bkp_file"
	fi
	ln -s $new_file $original_file
	echo "Success replacing $original_file --> $new_file. Backup available at $bkp_file"
    fi
}

backup_local_dotfiles() {

    local BASHRC=$HOME/.bashrc
    local NEW_BASHRC=$__DOTFILES_DIR__/bashrc
    local BKP_BASHRC=$HOME/.bashrc.d/50-bashrc.sh
    replace_file $BASHRC $NEW_BASHRC $BKP_BASHRC
    echo "Put all your local bashrc configuration files in '$(dirname $BKP_BASHRC)'. They will get loaded automatically in alphabetical order."

    local VIM_DIR=$HOME/.vim
    local NEW_VIM_DIR=$__DOTFILES_DIR__/vim
    local BKP_VIM_DIR=$HOME/.vim_bkp_dir
    replace_file $VIM_DIR $NEW_VIM_DIR $BKP_VIM_DIR

    local VIMRC=$HOME/.vimrc
    local NEW_VIMRC=$NEW_VIM_DIR/vimrc
    local BKP_VIMRC=$HOME/.vimrc_bkp_file
    replace_file $VIMRC $NEW_VIMRC $BKP_VIMRC

    local NVM_ORIG_DIR=${NVM_DIR}
    local NEW_NVM_DIR=${__DOTFILES_DIR__}/nvm
    local BKP_NVM_DIR=${HOME}/.nvm_bkp
    replace_file ${NVM_ORIG_DIR} ${NEW_NVM_DIR} ${BKP_NVM_DIR}
}

get_well_known_dirs_definitions() {
    cat $__BASHRC_DIR__/bash_env_vars.sh | sed -n '/__WELL_KNOWN_DIRS_DEFINITION_BEGINS__/,/__WELL_KNOWN_DIRS_DEFINITION_ENDS__/p' | grep 'export' | sed -n 's/^[[:space:]]*export[[:space:]]*\([_[:alnum:]]\+\)[[:space:]]*=.*$/\1/p'
}

ensure_all_well_known_dirs() {
    source $__BASHRC_DIR__/bash_env_vars.sh
    for dir in $(get_well_known_dirs_definitions)
    do
	local expanded_dir=$(eval "echo \$$dir")
	if [[ ! -d $expanded_dir ]]
	then
	    mkdir -p $expanded_dir
	    echo "Directory tree $expanded_dir initialized."
	fi
    done
}

main() {
    backup_local_dotfiles
    ensure_all_well_known_dirs
}

main
