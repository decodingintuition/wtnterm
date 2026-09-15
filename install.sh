#!/usr/bin/env bash
set -euo pipefail

repo_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)
config_dir="$HOME/.config"
backup_root="$HOME/.local/state/wtnterm/backups"
components=(wezterm tmux nvim)

for component in "${components[@]}"; do
    if [[ ! -d "$repo_dir/$component" ]]; then
        printf 'Missing configuration directory: %s\n' "$repo_dir/$component" >&2
        exit 1
    fi
done

mkdir -p -- "$config_dir"
backup_dir=""
for component in "${components[@]}"; do
    source_dir="$repo_dir/$component"
    target="$config_dir/$component"
    if [[ -L "$target" && "$(readlink -f -- "$target")" == "$source_dir" ]]; then
        printf 'Already linked: %s\n' "$target"
        continue
    fi
    if [[ -e "$target" || -L "$target" ]]; then
        if [[ -z "$backup_dir" ]]; then
            mkdir -p -- "$backup_root"
            backup_dir=$(mktemp -d "$backup_root/$(date +%Y%m%d-%H%M%S)-XXXXXX")
        fi
        mv -- "$target" "$backup_dir/$component"
        printf 'Preserved: %s\n' "$backup_dir/$component"
    fi
    ln -s -- "$source_dir" "$target"
    printf 'Linked: %s -> %s\n' "$target" "$source_dir"
done
