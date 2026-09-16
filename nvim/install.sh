#!/usr/bin/env bash
set -euo pipefail
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../scripts" && pwd -P)/install-common.sh"

install_packages nvim
link_config nvim
$links_only && exit 0
[[ ${NVIM_APPNAME:-nvim} == nvim ]] || fail 'Unset NVIM_APPNAME before installing the nvim configuration.'
for dependency in nvim git rg fd tree-sitter cc curl tar node; do
    require_command "$dependency"
done
nvim --headless -u NONE -l "$repo_dir/scripts/install-nvim.lua"
