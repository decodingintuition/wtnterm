# wtnterm

WezTerm, tmux, and Neovim configuration in `~/.config/wtnterm`.

| Directory | Configuration link |
| --- | --- |
| `wezterm/` | `~/.config/wezterm` |
| `tmux/` | `~/.config/tmux` |
| `nvim/` | `~/.config/nvim` |

## Installation

```sh
cd ~/.config/wtnterm
./install.sh
```

The installer preserves existing configurations under `~/.local/state/wtnterm/backups/` before creating links.

Matching links are skipped on subsequent runs.

Install tmux plugins with `bash tmux/setup.sh` or `Prefix + I` inside tmux.

Neovim installs its plugins through lazy.nvim on startup.

## Maintenance

Edit configuration through either the repository paths or the linked application paths.

Commit changes from this repository for all three applications.

The original Git histories are included in the imports.

Downloaded tmux plugins and local Neovim extras remain ignored by Git.
