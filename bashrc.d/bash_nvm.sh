#!/usr/bin/env bash

if [ -z ${__BASH_NVM__+x} ]
then
# First time this file is sourced
__BASH_NVM__="__BASH_NVM__"

# Actual script content
# ==============================================================================


[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# ==============================================================================
# End of actual script

fi # __BASH_NVM__
