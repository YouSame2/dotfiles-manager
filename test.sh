#!/usr/bin/env bash

MODE="cd"
OS_FLAG="u"

usage() {
    echo "Usage: $0 {add|sync|push|pull} {-m|-w} [-h]"
    echo "  {add|sync|push|pull|cd}        Set the MODE, default: cd"
    echo "  -m                             Set OS_FLAG to 'm'"
    echo "  -w                             Set OS_FLAG to 'w'"
    echo "  {-h|--h|--help}                Show this help message"
    exit 1
}

case "$1" in
    add|sync|push|pull|cd)
        MODE=$1
        shift # Remove the first argument after processing. idk this b4
        ;;

esac

# Parse the arguments
if [[ "$MODE" == "add" ]]; then
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
                if [ -z "$FILE" ]; then
                    FILE=$1
                else
                    echo "Error: Multiple files specified. Only one file is allowed for add."
                    usage
                fi
                shift
                ;;
        esac
    done

elif [[ "$MODE" == "push" || "$MODE" == "pull" ]]; then
GIT_ARGS=$@
echo $GIT_ARGS

# add push pull functionality here
fi


# Main logic based on the flags
echo "Running with MODE: $MODE and OS_FLAG: $OS_FLAG"
echo "file: $FILE"
echo ''

if [ "$MODE" == "add" ]; then
    echo "Add MODE selected"
    # Add MODE logic here
elif [ "$MODE" == "sync" ]; then
    echo "Sync MODE selected"
    # Sync MODE logic here
fi

if [ "$OS_FLAG" == "m" ]; then
    echo "Operating system set to 'm'"
    # Logic for OS_FLAG 'm' here
elif [ "$OS_FLAG" == "w" ]; then
    echo "Operating system set to 'w'"
    # Logic for OS_FLAG 'w' here
fi
