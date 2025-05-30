#!/usr/bin/env bash

__SETUP_SCRIPT_DIR__=$( cd -L "$( dirname "$(readlink -f "${BASH_SOURCE[0]}")" )" && pwd  )

__DOTFILES_DIR__=$(readlink -f "${__SETUP_SCRIPT_DIR__}")

__BASHRC_DIR__=${__DOTFILES_DIR__}/bashrc.d

if [[ "$OSTYPE" == "msys"* ]]; then
    export MSYS=winsymlinks:nativestrict
fi

function replace_file() {

    local original_file="$1"
    local new_file="$2"
    local bkp_file="$3"

    if [[ "$(readlink "${original_file}")" == "${new_file}" ]]
    then
	echo "${original_file} is already replaced with ${new_file}"
	return 0
    fi

    if [[ -e "${bkp_file}" ]]
    then
	echo "WARNING: Backup file is already present"
	return 1
    else
	if [[ -e "${original_file}" ]]
	then
	    echo "Creating dir $(dirname "${bkp_file}")"
	    mkdir -p "$(dirname "${bkp_file}")"
	    mv "${original_file}" "${bkp_file}"
	    echo "${original_file} has been backed up to ${bkp_file}"
	fi

	if ln -s "${new_file}" "${original_file}"
	then
	    echo "Success replacing ${original_file} --> ${new_file}"
	fi
    fi
}

function backup_local_dotfiles() {

    BASHRC="${HOME}/.bashrc"
    NEW_BASHRC="${__DOTFILES_DIR__}/bashrc"
    BKP_BASHRC="${HOME}/.bashrc.d/50-bashrc.sh"
    replace_file "${BASHRC}" "${NEW_BASHRC}" "${BKP_BASHRC}"
    echo "Put all your local bashrc configuration files in '$(dirname "${BKP_BASHRC}")'. They will get loaded automatically in alphabetical order."

    VIM_DIR="${HOME}/.vim"
    NEW_VIM_DIR="${__DOTFILES_DIR__}/vim"
    BKP_VIM_DIR="${HOME}/.vim_bkp_dir"
    replace_file "${VIM_DIR}" "${NEW_VIM_DIR}" "${BKP_VIM_DIR}"

    VIMRC="${HOME}/.vimrc"
    NEW_VIMRC="${NEW_VIM_DIR}/vimrc"
    BKP_VIMRC="${HOME}/.vimrc_bkp_file"
    replace_file "${VIMRC}" "${NEW_VIMRC}" "${BKP_VIMRC}"
}

function get_well_known_dirs_definitions() {
    cat "${__BASHRC_DIR__}/01-bash_env_vars.sh" | sed -n '/__WELL_KNOWN_DIRS_DEFINITION_BEGINS__/,/__WELL_KNOWN_DIRS_DEFINITION_ENDS__/p' | grep 'export' | sed -n 's/^[[:space:]]*export[[:space:]]*\([_[:alnum:]]\+\)[[:space:]]*=.*$/\1/p'
}

function ensure_all_well_known_dirs() {
    echo "Ensuring well-known directories"
    source "${__BASHRC_DIR__}/01-bash_env_vars.sh"
    for dir in $(get_well_known_dirs_definitions)
    do
	local expanded_dir=$(eval "echo \$${dir}")
	if [[ ! -d "${expanded_dir}" ]]
	then
	    mkdir -p "${expanded_dir}"
	    echo "Directory tree ${expanded_dir} initialized."
        else
	    echo "Directory ${expanded_dir} already exits."
	fi
    done
}



function main() {
    backup_local_dotfiles
    ensure_all_well_known_dirs
}

main
