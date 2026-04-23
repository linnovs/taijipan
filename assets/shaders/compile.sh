#!/usr/bin/env bash

BASE_DIR=$(dirname $0)
SOURCE_DIR="$BASE_DIR/frag"
DEST_DIR="$BASE_DIR/qsb"

check_command() {
    if ! command -v $1 &> /dev/null
    then
        echo "$1 could not be found. Please install it and try again."
        exit
    fi
}

main() {
    check_command "qsb"

    local shader_name=$(basename "$1" .frag)

    echo "$(date +'%F %X') - Compiling $shader_name..."
    qsb --qt6 -o "$DEST_DIR/${shader_name}.frag.qsb" "$SOURCE_DIR/${shader_name}.frag"
    echo "$(date +'%F %X') - Compiled $shader_name to $DEST_DIR/${shader_name}.frag.qsb"
}

main $1
