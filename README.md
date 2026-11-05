# Neovim configuration

<div align="center">
  <img src="https://upload.wikimedia.org/wikipedia/commons/3/3a/Neovim-mark.svg" alt="Neovim Logo" width="200"/>
</div>

Personal Neovim configuration for Python/ML, Unity C#, a TypeScript/Next.js blog and Swift/iOS, with LSP, AI code assistance and a Snacks-based UI.

## Requirements

- Neovim >= 0.12 (uses the built-in `vim.lsp.config` and undotree)
- Git, `make`, ripgrep
- A [Nerd Font](https://www.nerdfonts.com/) (configured by default)
- Node.js / npm (language servers, prettierd, eslint_d)
- tree-sitter CLI: `npm install -g tree-sitter-cli` (Homebrew's `tree-sitter` formula has no CLI). nvim-treesitter's `main` branch compiles every parser with it.
- Rust / cargo: `brew install rust`. avante.nvim compiles its native libraries from source on every update.
- lolcat (dashboard gradient header), lazygit (`<leader>gg`)

Optional, per language:

- Swift / iOS: Xcode selected with `xcode-select`, plus `brew install xcode-build-server swiftformat swiftlint`
- Jupyter (molten): a Python with `pynvim` and `jupyter_client` set as `g:python3_host_prog`, `brew install imagemagick`, then `:UpdateRemotePlugins`

AI providers read their keys from the environment: `ANTHROPIC_API_KEY`, `MOONSHOT_API_KEY` (Kimi), `ZAI_API_KEY` (GLM), `DEEPSEEK_API_KEY`.

## Installation

```bash
# Backup existing config (if any)
mv ~/.config/nvim ~/.config/nvim.bak

# Clone this repository
git clone https://github.com/r0llingclouds/nvim.git ~/.config/nvim

# Start Neovim (plugins install from the pinned lazy-lock.json)
nvim
```

## Features

### Plugins and LSP
- **lazy.nvim** - plugin manager; `lazy-lock.json` is tracked so a fresh clone gets tested versions
- **nvim-lspconfig** with the native `vim.lsp.config` / `vim.lsp.enable` API
- **mason.nvim**, **mason-lspconfig**, **mason-tool-installer** - install servers, formatters and linters
- **blink.cmp** + **LuaSnip** - completion and snippets
- **lazydev.nvim**, **fidget.nvim**, **SchemaStore.nvim**

### AI
- **avante.nvim** - chat and inline edits. Providers: Claude Sonnet 5.5 (default), Kimi K3, GLM 5.3, DeepSeek
- **blink-cmp-avante**, **img-clip.nvim** (paste images), **render-markdown.nvim**

### Search and navigation
- **telescope.nvim** (+ fzf-native, ui-select) - files, grep, help, LSP pickers
- **snacks.nvim** picker - TODO searches, colorschemes, `gd` / `gr`
- **flash.nvim** - `s` / `S` jumps
- **harpoon** (harpoon2), **vim-tmux-navigator**, **trouble.nvim**, **persistence.nvim** (sessions)

### UI
- **snacks.nvim** - dashboard, explorer, scroll, dim, bigfile, quickfile, bufdelete, lazygit, git browse
- **bufferline.nvim**, **noice.nvim** + **nvim-notify**, **which-key.nvim** (helix preset), **mini.statusline**
- **nvim-treesitter-context**, **indent-blankline.nvim** + **mini.indentscope**
- Custom zen mode and transparency toggle (`lua/plugins/ui.lua`)
- Colorschemes: dracula (default), tokyonight, catppuccin, kanagawa, zenbones, everforest, gruvbox, koda, monokai-pro, hardhat

### Editing
- **nvim-treesitter** (`main` branch) + **textobjects**
- **mini.ai**, **mini.surround** (on the `gs` prefix, so flash owns `s`), **nvim-autopairs**
- **conform.nvim** (format on save), **nvim-lint**
- **todo-comments.nvim**, **guess-indent.nvim**
- Neovim's built-in undotree

### Languages, debugging and tests
- C# / Unity: **roslyn.nvim**, **easy-dotnet.nvim**, **nvim-dap-unity**
- Python: **venv-selector.nvim**, **nvim-dap-python**
- Swift / iOS: sourcekit-lsp, **xcodebuild.nvim**
- Web: **nvim-ts-autotag**, **nvim-ts-context-commentstring**, **package-info.nvim**, **nvim-highlight-colors**
- Jupyter: **molten-nvim**, **image.nvim**, **jupytext.nvim**
- **nvim-dap** + **nvim-dap-ui** + **mason-nvim-dap** (debugpy, netcoredbg, codelldb)
- **neotest** with the Python and .NET adapters

## Language Support

| Language | LSP server | Formatter / linter |
|----------|------------|--------------------|
| Lua | lua_ls | stylua |
| Python | basedpyright (types, hover) + ruff | ruff (fix, organize imports, format) |
| C# (Unity) | roslyn | csharpier |
| JavaScript / TypeScript | vtsls, tailwindcss, emmet | prettierd, eslint_d |
| HTML / CSS | html, cssls | prettierd |
| JSON / YAML | jsonls, yamlls (SchemaStore) | prettierd |
| TOML | - | taplo |
| Markdown | - | prettierd (manual `<leader>f` only), markdownlint (on demand, `<leader>ul`) |
| Swift | sourcekit-lsp* | swiftformat*, swiftlint* |

\* From Xcode or Homebrew, not Mason.

Mason installs:

- **LSP servers:** lua-language-server, basedpyright, ruff, vtsls, tailwindcss-language-server, css-lsp, html-lsp, emmet-language-server, json-lsp, yaml-language-server, plus `roslyn` from the extra Crashdummyy registry (`:MasonInstall roslyn`)
- **Formatters / linters:** stylua, csharpier, prettierd, ruff, eslint_d, markdownlint, taplo
- **Debug adapters:** debugpy, netcoredbg, codelldb

## Key Mappings

Leader key: `<Space>`. `<leader>?` shows the keymaps for the current buffer.

### General
| Key | Description |
|-----|-------------|
| `<Esc>` | Clear search highlights |
| `<leader>f` | Format buffer |
| `<leader>uf` / `<leader>uF` | Toggle format on save (global / buffer) |
| `<leader>r` | Substitute in file (type target and replacement) |
| `<leader>R` | Substitute the word under the cursor, or the selection |
| `<leader>U` | Undotree |
| `s` / `S` | Flash jump / Flash treesitter selection |
| `<Esc><Esc>` | Leave terminal mode |

### Search
| Key | Description |
|-----|-------------|
| `<leader><leader>` | Find files |
| `<leader>sg` | Live grep |
| `<leader>sw` | Grep word under cursor |
| `<leader>s/` | Grep in open files |
| `<leader>/` | Fuzzy search in current buffer |
| `<leader>s.` | Recent files |
| `<leader>sr` | Resume last search |
| `<leader>sh` / `<leader>sk` | Help / keymaps |
| `<leader>sd` | Diagnostics |
| `<leader>ss` | Telescope pickers |
| `<leader>st` / `<leader>sf` / `<leader>sn` | TODOs / FIX and BUG comments / NOTE comments |
| `<leader>e` | File explorer |

### Buffers
| Key | Description |
|-----|-------------|
| `<S-h>` / `<S-l>` | Previous / next buffer |
| `<leader>bb` or ``<leader>` `` | Alternate buffer |
| `<leader>bd` / `<leader>bD` | Delete buffer / delete buffer and window |
| `<leader>bo` | Delete other buffers |
| `<leader>bp` / `<leader>bP` | Pin buffer / close unpinned |
| `<leader>bh` / `<leader>bl` | Close buffers to the left / right |
| `<leader>bz` | Zen mode |

### Harpoon
| Key | Description |
|-----|-------------|
| `<leader>ma` | Add file |
| `<leader>mm` | Menu |
| `<leader>m1` … `<leader>m4` | Jump to file 1-4 |
| `<leader>mp` / `<leader>mn` | Previous / next |

### Windows and sessions
| Key | Description |
|-----|-------------|
| `<C-h/j/k/l>` | Move between windows and tmux panes |
| `<C-Up/Down/Left/Right>` | Resize |
| `<leader>w` | Window commands (`<C-w>`) |
| `<C-w><Space>` | Window hydra mode |
| `<leader>qs` / `<leader>ql` | Restore session for this folder / last session |
| `<leader>qd` | Don't save the current session |

### LSP and code
| Key | Description |
|-----|-------------|
| `gd` / `gr` | Definition / references (Snacks) |
| `grd` / `grr` | Definition / references (Telescope) |
| `gri` / `grt` | Implementation / type definition |
| `grD` | Declaration |
| `grn` / `gra` | Rename / code action |
| `gO` / `gW` | Document / workspace symbols |
| `<leader>th` | Toggle inlay hints |
| `af` `if` / `ac` `ic` / `aa` `ia` | Function / class / parameter text objects |
| `]f` / `[f` | Next / previous function |
| `<leader>cp` | Swap parameter with the next one |
| `gsa` `gsd` `gsr` | Add / delete / replace surrounding |

### Diagnostics
| Key | Description |
|-----|-------------|
| `<leader>xx` / `<leader>xX` | All / buffer diagnostics (Trouble) |
| `<leader>xs` / `<leader>xl` | Symbols / location list (Trouble) |
| `<leader>xq` | Diagnostics to location list |
| `<leader>ul` | Lint the current buffer now |

### Completion (insert mode)
| Key | Description |
|-----|-------------|
| `<Enter>` | Accept |
| `<C-j>` / `<C-k>` | Next / previous item |
| `<C-Space>` | Show menu or documentation |

### Avante (AI)
| Key | Description |
|-----|-------------|
| `<leader>aa` | Open Avante |
| `<leader>ak` | Ask (normal or visual) |
| `<leader>ae` | Edit the selection |
| `<leader>ar` | Refresh |
| `<leader>ap` | Switch provider |
| `<leader>a?` / `<leader>ah` | Pick model / chat history (after Avante loads) |
| `<leader>ac` / `<leader>aB` | Add current buffer / all buffers to context |
| `<leader>aS` | Stop the response |

In the sidebar: `a` / `A` apply change at cursor / all, `r` retry, `e` edit request, `@` / `d` add / remove file, `<Tab>` switch windows, `]p` / `[p` next / previous prompt, `q` close. In diffs: `co` ours, `ct` theirs, `cb` both, `]x` / `[x` next / previous conflict.

### Git
| Key | Description |
|-----|-------------|
| `]c` / `[c` | Next / previous hunk |
| `<leader>hs` / `<leader>hr` | Stage / reset hunk (normal or visual) |
| `<leader>hS` / `<leader>hR` | Stage / reset buffer |
| `<leader>hu` | Undo stage hunk |
| `<leader>hp` / `<leader>hb` | Preview hunk / blame line |
| `<leader>hd` / `<leader>hD` | Diff against index / last commit |
| `<leader>tb` / `<leader>tD` | Toggle line blame / deleted lines |
| `<leader>gg` / `<leader>gb` | Lazygit / open in browser |

### Tests and debugging
| Key | Description |
|-----|-------------|
| `<leader>tt` / `<leader>tf` | Run nearest test / file |
| `<leader>ts` / `<leader>to` | Test summary / output |
| `<leader>td` | Debug nearest test |
| `<F5>` | Start / continue debugging |
| `<F1>` / `<F2>` / `<F3>` | Step into / over / out |
| `<F7>` | Toggle debug UI |
| `<leader>db` / `<leader>dB` | Toggle breakpoint / conditional breakpoint |

### Languages
| Key | Description |
|-----|-------------|
| `<leader>vs` | Select Python virtualenv |
| `<leader>nb` / `<leader>nt` / `<leader>nr` | .NET build / test / run |
| `<leader>X` | Xcode actions picker |
| `<leader>Xb` / `<leader>Xr` / `<leader>Xt` | Xcode build / build and run / test |
| `<leader>Xd` / `<leader>Xl` | Select device / toggle logs |
| `<leader>ji` | Start a Jupyter kernel (molten) |
| `<leader>jl` / `<leader>je` / `<leader>jv` | Run line / operator / selection |
| `<leader>jr` / `<leader>jo` / `<leader>jd` | Re-run cell / show output / delete cell |

### UI toggles
| Key | Description |
|-----|-------------|
| `<leader>uc` | Colorscheme picker |
| `<leader>ud` | Light / dark |
| `<leader>ut` | Transparency |
| `<leader>uw` | Line wrap |
| `<leader>tm` | Render markdown in this buffer |

## Structure

```
~/.config/nvim/
├── init.lua                  # Entry point (loads core modules)
├── lua/
│   ├── core/
│   │   ├── options.lua       # Vim options
│   │   ├── keymaps.lua       # Non-plugin keymaps
│   │   ├── autocmds.lua      # Autocommands
│   │   ├── filetypes.lua     # Unity / shader filetype overrides
│   │   └── lazy.lua          # Plugin manager setup
│   ├── plugins/              # One file per area, auto-imported by lazy.nvim
│   │   ├── avante.lua        # AI assistant
│   │   ├── colorscheme.lua
│   │   ├── completion.lua    # blink.cmp + LuaSnip
│   │   ├── debug.lua         # nvim-dap
│   │   ├── dotnet.lua        # easy-dotnet
│   │   ├── editor.lua        # which-key, autopairs, mini.*, todo-comments
│   │   ├── formatting.lua    # conform
│   │   ├── git.lua           # gitsigns
│   │   ├── harpoon.lua
│   │   ├── indent.lua
│   │   ├── lazydev.lua
│   │   ├── lint.lua          # nvim-lint
│   │   ├── lsp.lua           # servers, Mason, diagnostics
│   │   ├── molten.lua        # Jupyter
│   │   ├── motions.lua       # flash, trouble, persistence
│   │   ├── neotest.lua
│   │   ├── python.lua        # venv-selector
│   │   ├── roslyn.lua        # C# / Unity LSP
│   │   ├── swift.lua         # sourcekit-lsp + xcodebuild
│   │   ├── telescope.lua
│   │   ├── tmux.lua
│   │   ├── treesitter.lua
│   │   ├── ui.lua            # snacks, bufferline, noice
│   │   └── web.lua           # autotag, commentstring, package-info, colors
│   └── assets/               # Dashboard header
│       ├── header.txt
│       └── header.cat
└── lazy-lock.json
```

## Customization

Add plugins by creating new files in `lua/plugins/`; lazy.nvim imports every file there.

To change the default colorscheme, edit the theme with `priority = 1000` in `lua/plugins/colorscheme.lua`:
```lua
vim.cmd.colorscheme 'dracula'
```

Or pick one interactively with `<leader>uc`.
