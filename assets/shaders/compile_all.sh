#!/usr/bin/env bash

BASE_DIR=$(dirname $0)
SOURCE_DIR="$BASE_DIR/frag"

get_shader_files() {
    find $SOURCE_DIR -type f -name "*.frag"
}

main() {
    local shader_files=( $(get_shader_files) )

    for shader_file in "${shader_files[@]}"; do
        $BASE_DIR/compile.sh "$shader_file"
    done
}

main
