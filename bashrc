# NOTE: Put all your local bashrc configuration files in $HOME/.bashrc.d.
# They will get loaded automatically in alphabetical order.
#
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

__BASHRC_SCRIPT_DIR__=$( cd -L "$( dirname "$(readlink -f "${BASH_SOURCE[0]}")" )" && pwd  )


if [[ "$OSTYPE" == "msys"* ]]; then
    export MSYS=winsymlinks:nativestrict
fi

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Source files from repo
for conf_file in $(\ls "${__BASHRC_SCRIPT_DIR__}/bashrc.d/")
do
  source "${__BASHRC_SCRIPT_DIR__}/bashrc.d/${conf_file}"
done

# Source files from HOME
for conf_file in $(\ls "${HOME}/.bashrc.d/")
do
  source "${HOME}/.bashrc.d/${conf_file}"
done
