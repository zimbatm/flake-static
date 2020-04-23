#!/usr/bin/env bash
system=$(nix-instantiate --eval --expr builtins.currentSystem | xargs)
archive_name=bash-${system}.gz
archive_path=build/$archive_name
bin_name=bash-${system}
bin_path=build/$bin_name

# Build
rm -rf build
mkdir -p build

nix-build -A archive -o "$archive_path"
nix-build -A bin -o "$bin_path"

# Set outputs
echo "::set-output name=archive-name::$archive_name"
echo "::set-output name=archive-path::$archive_path"
echo "::set-output name=bin-name::$bin_name"
echo "::set-output name=bin-path::$bin_path"
