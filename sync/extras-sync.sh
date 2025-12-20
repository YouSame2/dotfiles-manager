#!/bin/bash

# insert additional commands to run at the end of bootstrapping below.
# keep what you want these are just examples:

# Global extras:
# ya pack -a yazi-rs/plugins:git

# OS and OS_TYPE are expected to be set by `dotfiles.sh` (sourced)

# windows part
# if [[ "$OS" =~ Cygwin|Msys|MinGW ]]; then
# fi

#   # $EDITOR=nvim
#   [[ -z "${EDITOR}" ]] && \
#   powershell.exe -Command "[System.Environment]::SetEnvironmentVariable('EDITOR', 'nvim', 'User')" && \
#   echo 'set EDITOR as nvim...' || \
#   echo '$EDITOR already set...'

#   echo 'installing/upgrading eza' && winget install eza-community.eza
#   echo 'installing/upgrading yazi' && winget install sxyazi.yazi
  
# mac part
# elif [[ "$OS" = Darwin ]]; then
# fi

# Linux/Arch part
# elif [[ "$OS" = GNU/Linux ]] || [[ "$OS" = Linux ]]; then
# fi
