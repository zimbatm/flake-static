#!/usr/bin/env bash
set -euo pipefail

# Build directory
rm -rf build
mkdir -p build

for attr in $(nix-instantiate --eval --expr '(builtins.attrNames (import ./.  {}))' --json | jq -r .[]) ; do
  echo "--- attr=$attr"
  nix-build -A "$attr" -o ./result
  filename=$(readlink ./result | cut -d - -f 2-)
  cp -rv "$(readlink ./result)" "./build/$filename"
done
