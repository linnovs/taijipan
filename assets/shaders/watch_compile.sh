#!/usr/bin/env bash

BASE_DIR=$(dirname $0)
SOURCE_DIR="$BASE_DIR/frag"
EXIT=0

trap "EXIT=1" SIGINT

check_command() {
    if ! command -v $1 &> /dev/null
    then
        echo "$1 could not be found. Please install it and try again."
        exit
    fi
}

main() {
    check_command "entr"

    while [ $EXIT -eq 0 ]; do
        find $SOURCE_DIR -type f -name "*.frag" | entr -pz "$BASE_DIR/compile.sh" /_

        if [ $EXIT -ne 0 ]; then
            echo "$(date +'%F %s') - Exiting shader watch loop"
            break
        fi

        # kill running quickshell after shader compile
        qs kill &>/dev/null && echo "$(date +'%F %s') - Killed running quickshell after compile"
    done
}

main
