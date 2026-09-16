#!/usr/bin/env bash
set -euo pipefail

project_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)
test_dir=$(mktemp -d "${TMPDIR:-/tmp}/wtnterm-install-test.XXXXXX")
trap 'rm -rf "$test_dir"' EXIT
source "$project_dir/scripts/install-common.sh" --links-only
repo_dir="$test_dir/repo with spaces"
config_dir="$test_dir/config"
backup_root="$test_dir/backups"
mkdir -p "$repo_dir/nvim" "$config_dir"
printf 'configuration\n' > "$repo_dir/nvim/init.lua"
printf 'original\n' > "$config_dir/nvim"

link_config nvim
[[ -L "$config_dir/nvim" ]]
[[ $(cat "$config_dir/nvim/init.lua") == configuration ]]
[[ $(cat "$backup_root"/*/nvim) == original ]]
first_backups=$(find "$backup_root" -type f | wc -l)
link_config nvim
[[ $(find "$backup_root" -type f | wc -l) == "$first_backups" ]]
rm "$config_dir/nvim"
ln -s "$test_dir/missing" "$config_dir/nvim"
link_config nvim
[[ $(cd "$config_dir/nvim" && pwd -P) == "$repo_dir/nvim" ]]
[[ $(find "$backup_root" -type l | wc -l) -eq 1 ]]

# Exercise package choices without invoking package managers.
skip_packages=false
uname() { printf 'Darwin\n'; }
brew() { printf 'brew %s\n' "$*" >> "$test_dir/packages"; }
xcode-select() { return 0; }
install_packages wezterm
install_packages tmux
install_packages nvim
cat > "$test_dir/expected" <<'EXPECTED'
brew install --cask wezterm
brew install tmux git
brew install neovim git ripgrep fd tree-sitter-cli node python lua curl
EXPECTED
diff -u "$test_dir/expected" "$test_dir/packages"
xcode-select() { return 1; }
if (install_packages nvim) > "$test_dir/error" 2>&1; then
    fail 'Missing Command Line Tools should fail'
fi
grep -q 'xcode-select --install' "$test_dir/error"

if [[ -f /etc/arch-release ]]; then
    uname() { printf 'Linux\n'; }
    pacman() { printf 'pacman %s\n' "$*" >> "$test_dir/arch-packages"; }
    sudo() { "$@"; }
    install_packages wezterm
    install_packages tmux
    install_packages nvim
    cat > "$test_dir/arch-expected" <<'EXPECTED'
pacman -S --needed wezterm ttf-jetbrains-mono ttf-nerd-fonts-symbols-mono
pacman -S --needed tmux git wl-clipboard xclip
pacman -S --needed neovim git ripgrep fd tree-sitter-cli nodejs base-devel curl tar python lua
EXPECTED
    diff -u "$test_dir/arch-expected" "$test_dir/arch-packages"
fi

uname() { printf 'Unsupported\n'; }
if (install_packages wezterm) > /dev/null 2>&1; then
    fail 'Unsupported platforms should fail'
fi
skip_packages=true
install_packages wezterm

bash "$project_dir/install.sh" --help > /dev/null
if bash "$project_dir/install.sh" wezterm invalid > /dev/null 2>&1; then
    fail 'Unknown arguments should fail before installation'
fi
for component in wezterm tmux nvim; do
    bash "$project_dir/$component/install.sh" --help > /dev/null
done
printf 'Installer checks passed\n'
