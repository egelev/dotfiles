#!/usr/bin/env bash

if [ -z ${__TEMPLATE__+x} ]
then
# First time this file is sourced
__TEMPLATE__="__TEMPLATE__"

# Actual script content
# ==============================================================================  

__TEMPLATE_SCRIPT_DIR__=$( cd -L $( dirname $(readlink -f "${BASH_SOURCE[0]}") ) && pwd  )


# ==============================================================================  
# End of actual script

fi # __TEMPLATE__
