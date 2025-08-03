# 💤 LazyVim Configuration

My personal Neovim setup built on top of [LazyVim](https://www.lazyvim.org/), featuring multiple colorschemes, AI assistance, and enhanced development tools.

## Features

- **Base**: LazyVim distribution for a solid foundation
- **AI Integration**: 
  - GitHub Copilot with custom keymaps (`<C-J>` to accept)
  - Avante.nvim for Claude AI chat integration
- **Multiple Colorschemes**: Tokyo Night (default), Catppuccin, Dracula, Everforest, Kanagawa, Monokai Pro, Rose Pine, Scholar, and Zenbones
- **Language Support**: Enhanced LSP configurations for C#, Swift, TypeScript, SQL, and more
- **Productivity**: Tmux navigation, custom keymaps, and Molten for notebook-style coding

## Terminal Setup

- **Terminal**: [Ghostty](https://ghostty.org/) - A fast, feature-rich terminal emulator
- **Multiplexer**: tmux with TPM (Tmux Plugin Manager)
  - **Theme**: Catppuccin with custom status bar
  - **Navigation**: vim-tmux-navigator for unified pane switching
  - **Prefix**: `C-s` (Ctrl+s)
  - **Pane Management**: 
    - `<prefix> h/j/k/l` - Resize panes
    - `<prefix> x` - Kill pane
    - `<prefix> r` - Reload config
- **Workflow**: Split layout with Neovim (left pane) + AI assistant (right pane)
  - Primary: [Claude Code](https://docs.anthropic.com/en/docs/claude-code/overview)
  - Alternative: [OpenCode](https://opencode.ai) with LLMs via [OpenRouter](https://openrouter.ai) API (test models like Kimi K2 or Qwen3)

## Key Mappings

- `<C-h/j/k/l>` - Navigate between tmux panes and Neovim splits seamlessly
- `<C-J>` - Accept Copilot suggestion
- `<leader>rg` - Replace word under cursor globally

## Notable Plugins

- **avante.nvim** - Claude AI integration for code assistance
- **copilot.vim** - GitHub Copilot support
- **vim-tmux-navigator** - Seamless tmux/vim navigation
- **molten.nvim** - Interactive code evaluation
- **Multiple LSP servers** via Mason

## Installation

1. Backup your existing Neovim config
2. Clone this repository:
   ```bash
   git clone https://github.com/r0llingclouds/nvim ~/.config/nvim
   ```
3. Start Neovim and let LazyVim install everything

## Requirements

- Neovim >= 0.9.0
- Git
- A [Nerd Font](https://www.nerdfonts.com/)
- Node.js (for Copilot)
- Python 3 (for Molten)
- [Claude Code](https://docs.anthropic.com/en/docs/claude-code/overview) (for AI-assisted development)

## Colorscheme

Default is Tokyo Night. Change in `lua/plugins/tokyo-night.lua` or use `:colorscheme` command.

## Tips

I like to experiment with my config, so I use this bash alias for quick backups:
```bash
alias bkvi='cp -r ~/.config/nvim ~/Desktop/nvim && cd ~/Desktop && zip -r nvim.zip nvim && rm -rf nvim && cd - > /dev/null && echo "✅ neovim back up 📦"'
```

## Resources

- [LazyVim Documentation](https://www.lazyvim.org/)
- [LazyVim for Ambitious Developers](https://lazyvim-ambitious-devs.phillips.codes/) - Great book to learn more about LazyVim
