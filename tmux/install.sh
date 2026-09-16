#!/usr/bin/env bash
set -euo pipefail
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../scripts" && pwd -P)/install-common.sh"

install_packages tmux
link_config tmux
$links_only && exit 0
require_command git
require_command tmux

# Install declared plugins without changing the running tmux server.
mkdir -p "$repo_dir/tmux/plugins"
while IFS= read -r plugin; do
    destination="$repo_dir/tmux/plugins/${plugin##*/}"
    if [[ -d "$destination/.git" ]]; then
        printf 'Already installed: %s\n' "$plugin"
    elif [[ -e "$destination" || -L "$destination" ]]; then
        fail "Plugin path already exists without a Git checkout: $destination"
    else
        git clone --recursive "https://github.com/$plugin" "$destination"
    fi
done < <(awk '/^set -g @plugin / { gsub(/[\047\042]/, "", $4); print $4 }' "$repo_dir/tmux/tmux.conf")
