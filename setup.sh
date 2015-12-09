#!/usr/bin/env bash

__SETUP_SCRIPT_DIR__=$( cd -L $( dirname $(readlink -f "${BASH_SOURCE[0]}") ) && pwd  )

__DOTFILES_DIR__=$(readlink -f $__SETUP_SCRIPT_DIR__)

replace_file() {

    local original_file=$1
    local new_file=$2
    local bkp_file=$3

    if [[ "$(readlink $original_file)" == "$new_file" ]]
    then
	echo "$original_file dir is already configured"
	return 0
    fi

    if [[ -e $bkp_file ]]
    then
	echo "Error: Backup file is already present"
	exit 1
    else
	if [[ -e $original_file ]]
	then
	    mv $original_file $bkp_file
	    echo "$original_file has been backed up to $bkp_file"
	fi
	ln -s $new_file $original_file 
	echo "Success"
    fi
}


BASHRC=$HOME/.bashrc
NEW_BASHRC=$__DOTFILES_DIR__/bashrc
BKP_BASHRC=$HOME/local_bashrc.sh

replace_file $BASHRC $NEW_BASHRC $BKP_BASHRC

VIM_DIR=$HOME/.vim
NEW_VIM_DIR=$__DOTFILES_DIR__/vim
BKP_VIM_DIR=$HOME/.vim_bkp_dir

replace_file $VIM_DIR $NEW_VIM_DIR $BKP_VIM_DIR


VIMRC=$HOME/.vimrc
NEW_VIMRC=$NEW_VIM_DIR/vimrc
BKP_VIMRC=$HOME/.vimrc_bkp_file

replace_file $VIMRC $NEW_VIMRC $BKP_VIMRC
