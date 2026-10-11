#!/usr/bin/env bash
set -euo pipefail
source "$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../scripts" && pwd -P)/install-common.sh"

install_packages zsh
link_config zsh
ensure_source_line "$HOME/.zshrc" 'source ~/.config/zsh/zshrc'
