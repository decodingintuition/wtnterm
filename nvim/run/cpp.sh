#!/usr/bin/env bash
set -e
src="$1"
bin="${src%.cpp}"
cat > "$src"
flags=("${@:2}")
[[ ${#flags[@]} -eq 0 ]] && flags=(-std=c++23 -O2)
g++ -o "$bin" "$src" "${flags[@]}" 2>&1
echo "$bin"
