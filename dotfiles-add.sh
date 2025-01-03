#!/usr/bin/env bash

# i couldnt find any other way to access my shell functions without sourcing this file. if anyone knows how to allow this subshell script to access .bashrc or .zshrc functions without sourcing let me know!
source ~/.config/aliases/.universal_aliases

set -e

# Ensure an argument is passed
if [ -z "$1" ]; then
  echo "Error: Please provide a file or directory as an argument."
  exit 1
fi

# set OS specific vars here 👇🏽
OS="$(uname -s)"

if [[ "$OS" =~ MINGW|CYGWIN|MSYS ]]; then
  SED_FLAG=""
elif [[ "$OS" == "Darwin" ]]; then
  SED_FLAG="\"\"" # mac sed requires backup flag after -i flag
fi

DOTFILES_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
CURRENT_DIR=$(dirs)

# TODO change install file 
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
sed -i $SED_FLAG "/- link:/a\ \ \ \ $CURRENT_DIR/$TARGET_NAME: $RELATIVE_PATH" "$INSTALL_FILE" || \
{ echo "Error: Please double check the files."; exit 1; }

# Confirmation
echo ''
echo "'$TARGET' has been added to 'install.conf.yaml' and moved to '$DOTFILES_DIR/$MKDIR_PATH'."
echo ''

# Create symlinks
dotfiles-sync