#!/usr/bin/env bash
set -e
src="$1"
bin="${src%.c}"
cat > "$src"
gcc -o "$bin" "$src" "${@:2}" 2>&1
echo "$bin"
