# Neovim Configuration

Personal Neovim configuration based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim).

## Requirements

- Neovim >= 0.10.0
- Git
- A [Nerd Font](https://www.nerdfonts.com/) (configured by default)
- `make` (for telescope-fzf-native)
- ripgrep (for live grep in Telescope)

## Installation

```bash
# Backup existing config (if any)
mv ~/.config/nvim ~/.config/nvim.bak

# Clone this repository
git clone https://github.com/r0llingclouds/nvim.git ~/.config/nvim

# Start Neovim (plugins will auto-install)
nvim
```

## Features

### Plugin Management
- **lazy.nvim** - Modern plugin manager with lazy loading

### LSP & Completion
- **nvim-lspconfig** - LSP configuration
- **mason.nvim** - Automatic LSP/tool installation
- **blink.cmp** - Fast autocompletion with snippet support
- **LuaSnip** - Snippet engine
- **lazydev.nvim** - Lua LSP enhancements for Neovim config

### Fuzzy Finding
- **telescope.nvim** - Fuzzy finder for files, grep, LSP symbols, and more
- **telescope-fzf-native** - FZF algorithm for faster sorting

### UI & Navigation
- **tokyonight.nvim** - Color scheme (night variant)
- **bufferline.nvim** - Buffer tabs with LSP diagnostics
- **snacks.nvim** - Dashboard, file explorer, picker, and buffer management
- **which-key.nvim** - Keybinding hints (helix preset)
- **mini.statusline** - Minimal statusline

### Editor Enhancements
- **treesitter** - Syntax highlighting and code understanding
- **gitsigns.nvim** - Git signs in the gutter
- **conform.nvim** - Code formatting (format on save)
- **mini.ai** - Enhanced text objects
- **mini.surround** - Surround operations
- **todo-comments.nvim** - Highlight TODO, FIXME, etc.
- **guess-indent.nvim** - Auto-detect indentation

## Key Mappings

Leader key: `<Space>`

### General
| Key | Description |
|-----|-------------|
| `<leader>?` | Show buffer keymaps |
| `<leader>/` | Fuzzy search in current buffer |
| `<leader>f` | Format buffer |
| `<Esc>` | Clear search highlights |

### File Navigation
| Key | Description |
|-----|-------------|
| `<leader><leader>` | Find files |
| `<leader>sf` | Search files |
| `<leader>sg` | Search by grep |
| `<leader>sr` | Resume last search |
| `<leader>s.` | Recent files |
| `<leader>sn` | Search Neovim config |
| `<leader>e` | Toggle file explorer |

### Buffer Management
| Key | Description |
|-----|-------------|
| `<S-h>` | Previous buffer |
| `<S-l>` | Next buffer |
| `<leader>bd` | Delete buffer |
| `<leader>bo` | Delete other buffers |
| `<leader>bb` | Switch to alternate buffer |
| `<leader>bp` | Pin buffer |

### Window Management
| Key | Description |
|-----|-------------|
| `<C-h/j/k/l>` | Navigate windows |
| `<C-Up/Down>` | Resize height |
| `<C-Left/Right>` | Resize width |
| `<leader>w` | Window commands (hydra mode) |

### LSP
| Key | Description |
|-----|-------------|
| `grd` | Go to definition |
| `grr` | Find references |
| `gri` | Go to implementation |
| `grn` | Rename symbol |
| `gra` | Code action |
| `gO` | Document symbols |
| `gW` | Workspace symbols |
| `<leader>th` | Toggle inlay hints |

### Git
| Key | Description |
|-----|-------------|
| `<leader>h` | Git hunk operations |

## Structure

```
~/.config/nvim/
├── init.lua              # Main configuration
├── lua/
│   ├── kickstart/        # Kickstart optional plugins
│   │   └── plugins/
│   └── custom/           # Custom plugins
│       └── plugins/
│           ├── bufferline.lua
│           └── snacks.lua
└── lazy-lock.json        # Plugin version lock
```

## Customization

Add custom plugins in `lua/custom/plugins/`. Files are automatically loaded by lazy.nvim.

## Credits

- [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) by TJ DeVries
