## Installation

```bash
git clone https://github.com/decodingintuition/tmux ~/.config/tmux
~/.config/tmux/setup.sh
```

## Key Bindings

**Prefix**: `Ctrl+Space` (Space again to forward prefix)

### Windows & Sessions
| Key | Action |
|-----|---------|
| `Prefix + r` | Reload config |
| `Prefix + I` | Install plugins |
| `Prefix + m` | Toggle mouse |
| `Prefix + c` | New window (with name) |
| `Prefix + n` | Rename window |
| `Prefix + w` | Swap window |
| `Prefix + s` | Jump find |

### Panes
| Key | Action |
|-----|---------|
| `Ctrl + h/j/k/l` | Navigate Neovim splits and tmux panes |
| `Ctrl + backslash` | Return to the previous split or pane |
| `Prefix + h/j/k/l` | Navigate panes (Vim-style) |
| `Prefix + \|` | Split vertically (preserve path) |
| `Prefix + -` | Split horizontally (preserve path) |
| `Prefix + H/J/K/L` | Resize panes (repeatable) |

### Copy/Visual
**Vim Bindings**: `v` (select), `y` (copy), `i` (exit)
