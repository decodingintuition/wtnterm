# wtnterm

WezTerm, tmux, and Neovim configuration in `~/.config/wtnterm`.

| Directory | Configuration link |
| --- | --- |
| `wezterm/` | `~/.config/wezterm` |
| `tmux/` | `~/.config/tmux` |
| `nvim/` | `~/.config/nvim` |

## Installation

Install Git before cloning, then run the installer as the normal login user.

```sh
git clone https://github.com/decodingintuition/wtnterm.git ~/.config/wtnterm
cd ~/.config/wtnterm
./install.sh
```

On macOS, install [Homebrew](https://brew.sh/) and Apple's Command Line Tools first with `xcode-select --install`.
The installer uses Homebrew for command-line tools and the [WezTerm cask](https://formulae.brew.sh/cask/wezterm).

On Arch Linux, update the system with `sudo pacman -Syu` first.
The installer uses `pacman -S --needed` with its normal confirmation prompts and `sudo` when needed.

| Component | Setup |
| --- | --- |
| WezTerm | Application, configuration, JetBrains Mono and symbol fonts |
| tmux | Application, clipboard tools, configuration, TPM and declared plugins |
| Neovim | Application, search tools, compiler, Tree-sitter CLI, Lua and Python runners, plugins and parsers |

WezTerm bundles its fonts on macOS, while Arch installs the [separate font packages](https://wezterm.org/install/linux.html).
The [Tree-sitter CLI](https://formulae.brew.sh/formula/tree-sitter-cli) is installed through the platform package manager.
Neovim requires version 0.12 or newer for the configured Tree-sitter plugin.
AI command-line tools and their authentication remain separate setup steps.

Install individual components through their own entry points:

```sh
./wezterm/install.sh
./tmux/install.sh
./nvim/install.sh
```

The top-level installer also accepts a selection, such as `./install.sh tmux nvim`.

| Option | Behavior |
| --- | --- |
| `--skip-packages` | Link configurations and install plugins using existing tools |
| `--links-only` | Create configuration links without installing packages or plugins |

Both options work with every installer.
Existing configurations are preserved under `~/.local/state/wtnterm/backups/` before replacement.
Matching links and existing tmux plugin checkouts are skipped on subsequent runs.
Neovim restores plugin versions from `lazy-lock.json` and waits for configured parsers to install.
Running tmux sessions are left intact, with new plugins available after `Prefix + r` or the next launch.

These configurations use `~/.config` directly, so `XDG_CONFIG_HOME` must be unset or point there.
Neovim setup expects the default `NVIM_APPNAME` of `nvim`.
Legacy `~/.wezterm.lua`, `~/.tmux.conf`, or `~/.config/wezterm.lua` files may take precedence and should be moved aside before using these configurations.

## Maintenance

Edit configuration through either the repository paths or the linked application paths.
Commit changes from this repository for all three applications.
The original Git histories are included in the imports.
Downloaded tmux plugins and local Neovim extras remain ignored by Git.

`tmux/setup.sh` remains a shortcut for `tmux/install.sh --skip-packages`.

Run installer checks with `bash tests/install.sh`.
These checks cover backups, repeated linking, argument handling, and mocked package commands.
