#!/usr/bin/env bash
set -euo pipefail

repo_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
components=()
options=()
for arg in "$@"; do
    case "$arg" in
        wezterm|tmux|nvim) components+=("$arg") ;;
        --skip-packages|--links-only) options+=("$arg") ;;
        -h|--help)
            printf 'Usage: %s [wezterm|tmux|nvim ...] [--skip-packages|--links-only]\n' "$0"
            exit 0 ;;
        *) printf 'Unknown argument: %s\n' "$arg" >&2; exit 1 ;;
    esac
done
if [[ ${#components[@]} -eq 0 ]]; then
    components=(wezterm tmux nvim)
fi
for component in "${components[@]}"; do
    bash "$repo_dir/$component/install.sh" ${options[@]+"${options[@]}"}
done
