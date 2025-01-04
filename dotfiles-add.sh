#!/usr/bin/env bash

set -e

# Ensure an argument is passed
if [ -z "$1" ]; then
  echo "Error: Please provide a file or directory as an argument."
  exit 1
fi

# Ensure target does not contain subdirs
if [[ "$1" == */* ]]; then
  echo "Error: '/' charc found! Subdirectories are not supported yet. To add Target file/directory please first cd to the parent directory of target"
  exit 1
fi

# i couldnt find any other way to access my shell functions without sourcing this file. if anyone knows how to allow this subshell script to access .bashrc or .zshrc functions without sourcing let me know!
source ~/.config/aliases/.universal_aliases

DOTFILES_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
CURRENT_DIR=$(dirs)

# TODO change install file 
INSTALL_FILE="$DOTFILES_DIR/install.conf.yaml"

TARGET=$1
TARGET_PATH=$(realpath "$TARGET")
TARGET_NAME=$(basename "$TARGET")

# idk how this works but its something about bash parameter expansion
RELATIVE_PATH=$(pwd)
MKDIR_PATH=${RELATIVE_PATH/$HOME/} # mkdir needs this 👈🏽 format
RELATIVE_PATH=$MKDIR_PATH/$TARGET
RELATIVE_PATH="${RELATIVE_PATH#/}"

# Check if the provided argument is valid
if [ ! -e "$TARGET_PATH" ]; then
  echo "Error: '$TARGET_PATH' does not exist."
  exit 1
fi

# --------------------
# EXPLANATION:
# --------------------
# ok so the below code is a little weird using sed on mac vs windows has diff behavior. so diff commands need to be used but ontop of that formating is CRITICAL. for example `" "$INSTALL_FILE"` NEEDS to be on a new line when in this if statement but doesnt have to outside of it? idk its weird.

# i spent way to much time trying to figure out why or how i can not make the code look weird, but no dice. theres probably a better unix util to use like aek but im a noobie so dont know. again if anyone can improve this im all ears.
# --------------------

# Make and move the target to the dotfiles directory
mkdir -p "$DOTFILES_DIR/$MKDIR_PATH" && \
mv -i "$TARGET" "$DOTFILES_DIR/$MKDIR_PATH" && \
# find os -> Append the target path to the 'links' section of install.conf.yaml
{ 
  OS="$(uname -s)"
  
  if [[ "$OS" == "Darwin" ]]; then
    sed -i '' "/- link:/a\\
    $CURRENT_DIR/$TARGET_NAME: $RELATIVE_PATH\\
" "$INSTALL_FILE"
  elif [[ "$OS" =~ MINGW|CYGWIN|MSYS ]]; then
    sed -i "/- link:/a\\
    $CURRENT_DIR/$TARGET_NAME: $RELATIVE_PATH\\" "$INSTALL_FILE"
  else
    echo "Unsupported OS: $OS" && exit 1
  fi
} || \
{ echo "Error: Please double check the files and OS compatibility."; exit 1; }


# Confirmation
echo ''
echo "'$TARGET' has been added to 'install.conf.yaml' and moved to '$DOTFILES_DIR/$MKDIR_PATH'."

# Create symlinks
dotfiles-sync



# yq command thats working
# yq -i '.[1].link.hello2 = "neo"' install.conf.yaml