#!/bin/bash

set -e

##########################
# init
##########################

# TODO: add check for elevated privileges. my god this pissed me off...

# TODO: add sync (running bootstrap.sh) and upgrade command (upgrade via each package manager)

[[ -z "$DOTFILES" ]] && echo "Dotfiles alias is not set please set and rerun script" && exit 1

source "$DOTFILES"/.config/global-rc/.global-aliases
source "$DOTFILES"/.config/global-rc/.global-rc
# CONTRIBUTE: i couldnt find any other way to access my shell functions without sourcing this file. has something to do with interactive shell vs subshell. if anyone knows how to allow this subshell script to access .bashrc or .zshrc functions without sourcing let me know!

usage() {
    echo "Usage: dotfiles <command> [options] <target>"
    echo ""
    echo "Commands:"
    echo ""
    echo "  add             Add a file or directory to the dotfiles repository and configure it for symlinking."
    echo ""
    echo "  link            Rerun the dotbot configuration to ensure all symlinks are created or updated."
    echo ""
    echo "  yeet            Add all changes, commit, and push to the remote repository. Any [options] that come after yeet get passed straight to 'git commit' as args. Note -m option for 'add' does not apply to 'yeet' and instead gets interpreted by git as a commit message. If no args are passed commit message defaults to 'YEET dotfiles'."
    echo ""
    echo "  yank            Pull the latest changes from the remote dotfiles repository."
    echo ""
    echo "Options for 'add':"
    echo "  -m              Set the target symlink to apply only on macOS."
    echo "  -w              Set the target symlink to apply only on Windows."
    echo ""
    echo "General Options:"
    echo "  -h, --help      Display this help message."
    echo ""
    echo "Examples:"
    echo "  dotfiles add config.lua          Add 'my_config' and configure it for all platforms."
    echo "  dotfiles add -m config.lua       Add 'my_config' and configure it for macOS only."
    echo "  dotfiles add -w config.lua       Add 'my_config' and configure it for Windows only."
    echo "  dotfiles link                   Ensure all symlinks are created or updated."
    echo "  dotfiles yeet                   Commit all changes with the default message and push."
    echo "  dotfiles yeet -m 'Fix issue'    Commit all changes with custom git commit args and push."
    echo "  dotfiles yank                   Pull the latest changes from the remote repository."
    exit 1
}


MODE=""
OS_FLAG="u"
TARGET=""

case "$1" in
    add|link|yeet|yank|bootstrap|backup)
        MODE=$1
        shift # Remove the first argument after processing. idk this b4
        ;;
        -h|--h|--help)
        usage
        ;;
        *)
        echo "Option $1 not recognized"
        echo ""
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
        cd "$DOTFILES" && git add . && git commit -m "YEET dotfiles" && git push
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
# bootstrap functionality
##########################

elif [[ "$MODE" == "bootstrap" ]]; then
    . "$DOTFILES"/dotfiles-manager/bootstrap.sh
    exit 0

elif [[ "$MODE" == "backup" ]]; then
    # Check OS
    OS=$(uname -o)

    # Mac backup:
    if [[ "$OS" = Darwin ]]; then
        echo "------- Backing up Mac HomeBrew recipes..."
        brew bundle dump --file="$DOTFILES/bootstrap/mac/Brewfile" --no-vscode --force

    # Windows backup:
    elif [[ "$OS" =~ Cygwin|Msys|MinGW ]]; then
        echo "------- Backing up Windows Choco packages..."
        choco export -o="$DOTFILES"/bootstrap/windows/packages.config
        
    else
        echo "Unsupported OS detected: $OS"  
    fi
    exit 0

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
