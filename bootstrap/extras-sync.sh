#!/bin/bash

# insert additional commands to run at the end of bootstrapping below.

# Global extras:
# ya pack -a yazi-rs/plugins:git # an example

# Check OS
OS=$(uname -o)

# windows part
if [[ "$OS" =~ Cygwin|Msys|MinGW ]]; then

# keep what you want these are just examples:

#   # $EDITOR=nvim
#   [[ -z "${EDITOR}" ]] && \
#   powershell.exe -Command "[System.Environment]::SetEnvironmentVariable('EDITOR', 'nvim', 'User')" && \
#   echo 'set EDITOR as nvim...' || \
#   echo '$EDITOR already set...'

#   # winget part: winget is werid on windows so just put it here
#   echo 'installing/upgrading eza' && winget install eza-community.eza
#   echo 'installing/upgrading yazi' && winget install sxyazi.yazi
  
# mac part
# elif [[ "$OS" = Darwin ]]; then
fi
