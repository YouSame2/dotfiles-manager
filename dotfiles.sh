#!/bin/bash

set -e

##########################
# init
##########################

if [[ -z "$DOTFILES" ]]; then
    echo "Dotfiles alias is not set please set and rerun script"
    exit 1
fi

source "$DOTFILES"/.config/global-rc/.global-aliases
source "$DOTFILES"/.config/global-rc/.global-rc
# CONTRIBUTE: i couldnt find any other way to access my shell functions without sourcing this file. if anyone knows how to allow this subshell script to access .bashrc or .zshrc functions without sourcing let me know!

usage() {
    echo "Usage: $0 {add|link|yeet|yank} {-m|-w} [-h]"
    echo "  {add|link|yeet|yank}             Set the MODE"
    echo "  -m                               Set OS_FLAG to 'm'"
    echo "  -w                               Set OS_FLAG to 'w'"
    echo "  {-h|--h|--help}                  Show this help message"
    exit 1
}

MODE=""
OS_FLAG="u"
TARGET=""

case "$1" in
    add|link|yeet|yank)
        MODE=$1
        shift # Remove the first argument after processing. idk this b4
        ;;
        -h|--h|--help)
        usage
        ;;
esac

##########################
# link functionality
##########################

if [ "$MODE" == "link" ]; then
    "$DOTFILES"/install
    exit 0

##########################
# git functionality
##########################

elif [[ "$MODE" == "yeet" ]]; then
    GIT_ARGS="$@"
    if [[ -z "$GIT_ARGS" ]]; then
        cd "$DOTFILES" && git add . && git commit -m '"YEET dotfiles"' && git push
        exit 0
    else
        cd "$DOTFILES" && git add . && git commit "$GIT_ARGS" && git push
        exit 0
    fi

elif [[ "$MODE" == "yank" ]]; then
    GIT_ARGS="$@"
    cd "$DOTFILES" && git pull
    exit 0

# decided not to do this... tbh just cd to dir and run git from there
# elif [[ "$MODE" == "commit" || "$MODE" == "push" || "$MODE" == "pull" ]]; then
#     GIT_ARGS="$@"
#     cd "$DOTFILES" && git "$MODE" "$GIT_ARGS"
#     exit 0

##########################
# add functionality
##########################

# Parse the arguments
elif [[ "$MODE" == "add" ]]; then
    while [[ $# -gt 0 ]]; do
        case $1 in 
            -m)
                OS_FLAG="m"
                shift
                ;;
            -w)
                OS_FLAG="w"
                shift
                ;;
            -h|--h|--help)
                usage
                ;;
            -*)
                echo "Unknown option: $1"
                usage
                ;;
            *)
                if [ -z "$TARGET" ]; then
                    TARGET=$1
                else
                    echo "Error: Multiple files specified. Only one file is allowed for add."
                    usage
                fi
                shift
                ;;
        esac
    done

    # ensure file provided
    if [ -z "$TARGET" ]; then
    echo "Error: Please provide a file or directory as an argument."
    exit 1
    fi

    # Ensure file does not contain subdirs
    if [[ "$TARGET" == */* ]]; then
    echo "Error: '/' charc found! Subdirectories are not supported yet. To add Target file/directory please first cd to the parent directory of target"
    exit 1
    fi

    CURRENT_DIR=$(dirs)
    INSTALL_FILE="$DOTFILES/install.conf.yaml"
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
    mkdir -p "$DOTFILES/$MKDIR_PATH" && \
    mv -i "$TARGET" "$DOTFILES/$MKDIR_PATH" && \
    
    # add path to config
    yq -i "(.[] | select(.link) | .[].\"$CURRENT_DIR/$TARGET_NAME\".path) = \"$RELATIVE_PATH\"" "$INSTALL_FILE" || \
    { echo "Error: Please double check the files and OS compatibility."; exit 1; }
    # 👆🏼 yq = confusing af...

    # handle OS_FLAGS
    if [[ $OS_FLAG == "w" ]]; then
        yq -i "(.[] | select(.link) | .[].\"$CURRENT_DIR/$TARGET_NAME\".if) = \"[ \`uname\` != Darwin ]\"" "$INSTALL_FILE"
        # CONTRIBUTE: I searched for a FULL DAY to figure out a way to detect windows in dotbot. i tried EVERY PERMUTATION, and trust me the only way is to check if its not mac... If any1 figures this out plz lmk. it actually pissed me off.

    elif [[ $OS_FLAG == "m" ]]; then
        yq -i "(.[] | select(.link) | .[].\"$CURRENT_DIR/$TARGET_NAME\".if) = \"[ \`uname\` = Darwin ]\"" "$INSTALL_FILE"
        # CONTRIBUTE: when adding file/folder with no OS_FLAG (i.e. 'dotfiles add .config') in 'install.conf.yaml', if that file/folder already had an if statement the if statement wont get removed. this can lead so some unexpected behavior in rare situations. Im probably not going to deal with it since its niche, but feel free for a simple contribution if u want.
    fi

    # Confirmation
    echo ''
    echo "'$TARGET' has been added to 'install.conf.yaml' and moved to '$DOTFILES/$MKDIR_PATH'."

    # Create symlinks
    "$DOTFILES"/install
    exit 0
fi
