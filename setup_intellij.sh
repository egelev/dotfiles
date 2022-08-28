#!/usr/bin/env bash

__SETUP_SCRIPT_DIR__=$( cd -L $( dirname $(readlink -f "${BASH_SOURCE[0]}") ) && pwd  )

__DOTFILES_DIR__=$(readlink -f ${__SETUP_SCRIPT_DIR__})

__BASHRC_DIR__=${__DOTFILES_DIR__}/bashrc.d

__INTELLIJ_DIR__=${__DOTFILES_DIR__}/intellij

function find_latest_intellij_config_dir() {
    echo $(ls -d ${HOME}/.config/JetBrains/*/ | sort -u | tail -n 1)
}

function copy_subdir() {
    local subsir=${1}

    local src=${__INTELLIJ_DIR__}/${subdir}
    local dst=$(find_latest_intellij_config_dir)/${subdir}

    echo "Copying the contents of '${src}' to '${dst}'"
    cp ${src}/* ${dst}/
}

function copy_keymaps() {
    copy_subdir "keymaps"
}

function copy_options() {
    copy_subdir "options"
}

function main() {
    copy_keymaps
    copy_options
}

main
