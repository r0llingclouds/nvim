# Neovim configuration

<div align="center">
  <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/3/3a/Neovim-mark.svg/1680px-Neovim-mark.svg.png" alt="Neovim Logo" width="200"/>
</div>

Personal Neovim configuration with LSP support, AI code assistance, and modern UI enhancements.

## Requirements

- Neovim >= 0.11.0
- Git
- A [Nerd Font](https://www.nerdfonts.com/) (configured by default)
- `make` (for telescope-fzf-native)
- ripgrep (for live grep)
- Node.js (for some language servers)
- lolcat (for dashboard gradient header)

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
- **avante.nvim** - AI-powered code assistant with chat interface (Cursor-like experience). Supports Claude and other LLM providers for code generation, editing, and explanation directly in the editor

### Fuzzy Finding
- **telescope.nvim** - Fuzzy finder for files, grep, LSP symbols
- **telescope-fzf-native** - FZF algorithm for faster sorting
- **snacks.picker** - Additional picker functionality

### UI & Navigation
- **dracula.nvim** - Default color scheme (classic dark theme)
- **tokyonight.nvim** - Popular night-inspired theme
- **catppuccin** - Popular pastel theme
- **kanagawa.nvim** - Wave-inspired theme
- **zenbones.nvim** - Minimal bone-colored themes
- **everforest-nvim** - Green-based comfortable theme
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
- **mini.indentscope** - Animated scope highlighting
- **indent-blankline.nvim** - Indent guides
- **nvim-autopairs** - Auto-close brackets and quotes
- **todo-comments.nvim** - Highlight TODO, FIXME, etc.
- **guess-indent.nvim** - Auto-detect indentation

## Language Support

I normally use the following:

| Language | LSP Server | Formatter/Linter |
|----------|------------|------------------|
| Lua | lua_ls | stylua |
| Swift | sourcekit-lsp* | - |
| C# (Unity) | omnisharp | csharpier |
| Python | basedpyright | ruff |
| JavaScript/TypeScript | ts_ls | prettierd |
| JSON | - | prettierd |

\* sourcekit-lsp is provided by Xcode toolchain, not Mason.

The following LSP servers and formatters are installed via Mason:

**LSP Servers:**
- `lua-language-server` (lua_ls)
- `basedpyright`
- `omnisharp`
- `typescript-language-server` (ts_ls)

**Formatters/Linters:**
- `stylua` - Lua formatter
- `csharpier` - C# formatter
- `ruff` - Python linter/formatter
- `prettierd` - JS/TS/JSON formatter

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
├── init.lua                    # Entry point (loads core modules)
├── lua/
│   ├── core/                   # Core configuration
│   │   ├── options.lua         # Vim options
│   │   ├── keymaps.lua         # Non-plugin keybindings
│   │   ├── autocmds.lua        # Autocommands
│   │   └── lazy.lua            # Plugin manager setup
│   ├── plugins/                # All plugin specs
│   │   ├── avante.lua
│   │   ├── colorscheme.lua
│   │   ├── completion.lua
│   │   ├── copilot.lua
│   │   ├── debug.lua
│   │   ├── editor.lua
│   │   ├── formatting.lua
│   │   ├── git.lua
│   │   ├── indent.lua
│   │   ├── lazydev.lua
│   │   ├── lint.lua
│   │   ├── lsp.lua
│   │   ├── swift.lua
│   │   ├── telescope.lua
│   │   ├── tmux.lua
│   │   ├── treesitter.lua
│   │   └── ui.lua
│   └── assets/                 # Dashboard assets
│       ├── header.txt
│       └── header.cat
└── lazy-lock.json
```

## Customization

Add custom plugins by creating new files in `lua/plugins/`. Files are automatically loaded by lazy.nvim.

To change the default colorscheme, edit `lua/plugins/colorscheme.lua` and modify the theme with `priority = 1000`:
```lua
vim.cmd.colorscheme 'dracula'
```

Or use `<leader>uc` to pick a colorscheme interactively.
