# Neovim Configuration

Personal Neovim configuration based on [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim), extended with LSP support, AI code assistance, and modern UI enhancements.

## Requirements

- Neovim >= 0.10.0
- Git
- A [Nerd Font](https://www.nerdfonts.com/) (configured by default)
- `make` (for telescope-fzf-native)
- ripgrep (for live grep)
- Node.js (for some language servers)

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
- **blink.cmp** - Fast autocompletion with fuzzy matching
- **LuaSnip** - Snippet engine
- **lazydev.nvim** - Lua LSP enhancements for Neovim config
- **fidget.nvim** - LSP progress indicator

### AI Assistance
- **copilot.lua** - GitHub Copilot integration with ghost text suggestions

### Fuzzy Finding
- **telescope.nvim** - Fuzzy finder for files, grep, LSP symbols
- **telescope-fzf-native** - FZF algorithm for faster sorting
- **snacks.picker** - Additional picker functionality

### UI & Navigation
- **tokyonight.nvim** - Default color scheme (night variant)
- **catppuccin** - Popular pastel theme
- **kanagawa.nvim** - Wave-inspired theme
- **zenbones.nvim** - Minimal bone-colored themes
- **everforest-nvim** - Green-based comfortable theme
- **dracula.nvim** - Classic dark theme
- **bufferline.nvim** - Buffer tabs with LSP diagnostics
- **snacks.nvim** - Dashboard, file explorer, picker, smooth scroll, zen mode
- **noice.nvim** - Floating cmdline, search, and notifications
- **which-key.nvim** - Keybinding hints (helix preset)
- **mini.statusline** - Minimal statusline
- **vim-tmux-navigator** - Seamless tmux/vim pane navigation

### Editor Enhancements
- **treesitter** - Syntax highlighting and code understanding
- **gitsigns.nvim** - Git signs in the gutter
- **conform.nvim** - Code formatting (format on save)
- **mini.ai** - Enhanced text objects
- **mini.surround** - Surround operations
- **todo-comments.nvim** - Highlight TODO, FIXME, etc.
- **guess-indent.nvim** - Auto-detect indentation

## Language Support

Configured with LSP and formatting for:

| Language | LSP Server | Formatter |
|----------|------------|-----------|
| Lua | lua_ls | stylua |
| C# (Unity) | omnisharp | csharpier |
| Python | basedpyright | ruff |
| JavaScript/TypeScript | ts_ls | prettierd |
| JSON | - | prettierd |

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
| `<leader>bz` | Toggle Zen mode |

### Window Management
| Key | Description |
|-----|-------------|
| `<C-h/j/k/l>` | Navigate windows (tmux-aware) |
| `<C-Up/Down>` | Resize height |
| `<C-Left/Right>` | Resize width |
| `<leader>w` | Window commands (hydra mode) |

### LSP
| Key | Description |
|-----|-------------|
| `gd` | Go to definition (Snacks picker) |
| `gr` | Find references (Snacks picker) |
| `grd` | Go to definition (Telescope) |
| `grr` | Find references (Telescope) |
| `gri` | Go to implementation |
| `grn` | Rename symbol |
| `gra` | Code action |
| `grD` | Go to declaration |
| `grt` | Go to type definition |
| `gO` | Document symbols |
| `gW` | Workspace symbols |
| `<leader>th` | Toggle inlay hints |

### Completion (Insert Mode)
| Key | Description |
|-----|-------------|
| `<Enter>` | Accept completion |
| `<C-j>` | Next suggestion |
| `<C-k>` | Previous suggestion |
| `<C-Space>` | Show documentation |

### Copilot (Insert Mode)
| Key | Description |
|-----|-------------|
| `<Tab>` | Accept suggestion |
| `<M-]>` | Next suggestion |
| `<M-[>` | Previous suggestion |
| `<C-]>` | Dismiss suggestion |

### UI Toggles
| Key | Description |
|-----|-------------|
| `<leader>uc` | Colorscheme picker |
| `<leader>ud` | Toggle light/dark mode |

### Git
| Key | Description |
|-----|-------------|
| `<leader>h` | Git hunk operations |

## Structure

```
~/.config/nvim/
├── init.lua                    # Main configuration
├── lua/
│   ├── kickstart/              # Kickstart optional plugins
│   │   └── plugins/
│   │       ├── autopairs.lua
│   │       ├── debug.lua
│   │       ├── gitsigns.lua
│   │       ├── indent_line.lua
│   │       ├── lint.lua
│   │       └── neo-tree.lua
│   └── custom/                 # Custom plugins
│       └── plugins/
│           ├── bufferline.lua  # Buffer tabs
│           ├── colorschemes.lua # Color themes
│           ├── completion.lua  # blink.cmp config
│           ├── copilot.lua     # GitHub Copilot
│           ├── formatting.lua  # conform.nvim
│           ├── lazydev.lua     # Lua dev tools
│           ├── lsp.lua         # LSP configuration
│           ├── noice.lua       # Floating UI
│           ├── nvim-tmux-navigator.lua
│           └── snacks.lua      # Dashboard, explorer, etc.
└── lazy-lock.json              # Plugin version lock
```

## Customization

Add custom plugins in `lua/custom/plugins/`. Files are automatically loaded by lazy.nvim.

To change the default colorscheme, edit `init.lua` and modify:
```lua
vim.cmd.colorscheme 'tokyonight-night'
```

Or use `<leader>uc` to pick a colorscheme interactively.

## Credits

- [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) by TJ DeVries
