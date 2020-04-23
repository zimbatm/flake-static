#!/usr/bin/env bash
rm -rf build
mkdir -p build
nix-build -A archive -o build/bash.tar.gz
nix-build -A bin -o build/bash
