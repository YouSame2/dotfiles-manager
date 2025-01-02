#!/usr/bin/env bash
# i couldnt find any other way to access my shell functions without sourcing this file. if anyone knows how to allow this subshell script to access .bashrc or .zshrc functions without sourcing let me know!

set -e

# Ensure an argument is passed
if [ -z "$1" ]; then
  echo "Error: Please provide a file or directory as an argument."
  exit 1
fi

DOTFILES_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
CURRENT_DIR=$(dirs)

INSTALL_FILE="$DOTFILES_DIR/windows-install.conf.yaml"

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

# Make and move the target to the dotfiles directory
mkdir -p "$DOTFILES_DIR/$MKDIR_PATH" && \
mv -i "$TARGET" "$DOTFILES_DIR/$MKDIR_PATH" && \
# Append the target path to the 'links' section of install.conf.yaml
      " "$INSTALL_FILE" || \
{ echo "Error: Please double check the files."; exit 1; }

# Confirmation
echo ''
echo "'$TARGET' has been added to 'install.conf.yaml' and moved to '$DOTFILES_DIR/$MKDIR_PATH'."
echo ''

# Create symlinks
dotfiles-sync