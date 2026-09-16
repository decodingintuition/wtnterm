#!/usr/bin/env bash

repo_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)
config_dir="$HOME/.config"
backup_root="$HOME/.local/state/wtnterm/backups"
skip_packages=false
links_only=false
for arg in "$@"; do
    case "$arg" in
        --skip-packages) skip_packages=true ;;
        --links-only) skip_packages=true; links_only=true ;;
        -h|--help)
            printf 'Usage: %s [--skip-packages|--links-only]\n' "$0"
            exit 0 ;;
        *) printf 'Unknown argument: %s\n' "$arg" >&2; exit 1 ;;
    esac
done

fail() {
    printf '%s\n' "$*" >&2
    exit 1
}

require_command() {
    command -v "$1" >/dev/null 2>&1 || fail "Missing command: $1"
}

if [[ ${XDG_CONFIG_HOME:-$config_dir} != "$config_dir" ]]; then
    fail 'These configurations require XDG_CONFIG_HOME to be unset or ~/.config.'
fi

install_packages() {
    $skip_packages && return 0
    case "$(uname -s)" in
        Darwin)
            require_command brew
            if [[ $1 == nvim ]]; then
                xcode-select -p >/dev/null 2>&1 || fail 'Install Command Line Tools with xcode-select --install, then rerun.'
            fi
            case "$1" in
                wezterm) brew install --cask wezterm ;;
                tmux) brew install tmux git ;;
                nvim) brew install neovim git ripgrep fd tree-sitter-cli node python lua curl ;;
            esac ;;
        Linux)
            [[ -f /etc/arch-release ]] || fail 'Automatic package installation supports macOS and Arch Linux.'
            require_command pacman
            local packages=()
            case "$1" in
                wezterm) packages=(wezterm ttf-jetbrains-mono ttf-nerd-fonts-symbols-mono) ;;
                tmux) packages=(tmux git wl-clipboard xclip) ;;
                nvim) packages=(neovim git ripgrep fd tree-sitter-cli nodejs base-devel curl tar python lua) ;;
            esac
            if [[ $EUID -eq 0 ]]; then
                pacman -S --needed "${packages[@]}"
            else
                require_command sudo
                sudo pacman -S --needed "${packages[@]}"
            fi ;;
        *) fail 'Automatic package installation supports macOS and Arch Linux.' ;;
    esac
}

link_config() {
    local component="$1"
    local source_dir="$repo_dir/$component"
    local target="$config_dir/$component"
    local resolved=""
    [[ -d "$source_dir" ]] || fail "Missing configuration directory: $source_dir"
    mkdir -p "$config_dir"
    if [[ -L "$target" && -d "$target" ]]; then
        resolved=$(cd -- "$target" && pwd -P)
    fi
    if [[ "$resolved" == "$source_dir" ]]; then
        printf 'Already linked: %s\n' "$target"
        return
    fi
    if [[ -e "$target" || -L "$target" ]]; then
        local backup_dir
        mkdir -p "$backup_root"
        backup_dir=$(mktemp -d "$backup_root/$(date +%Y%m%d-%H%M%S)-XXXXXX")
        mv "$target" "$backup_dir/$component"
        printf 'Preserved: %s\n' "$backup_dir/$component"
    fi
    ln -s "$source_dir" "$target"
    printf 'Linked: %s -> %s\n' "$target" "$source_dir"
}
