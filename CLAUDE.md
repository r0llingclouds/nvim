# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a Neovim configuration based on LazyVim. It's a personal dotfile repository for configuring Neovim with various plugins and settings.

## Key Architecture

### Structure
- `init.lua` - Entry point that loads the lazy.nvim configuration
- `lua/config/` - Core configuration files:
  - `lazy.lua` - Bootstrap and setup for lazy.nvim plugin manager
  - `autocmds.lua` - Auto commands
  - `keymaps.lua` - Key mappings
  - `options.lua` - Neovim options
- `lua/plugins/` - Plugin configurations, each file returns a plugin spec
- `lazyvim.json` - LazyVim extras configuration (includes Copilot and SQL support)

### Plugin Management
- Uses lazy.nvim as the plugin manager
- Plugins are defined in `lua/plugins/` directory
- Each plugin file returns a table with plugin specifications
- LazyVim is loaded as a base configuration with additional custom plugins

### Key Customizations
- Multiple colorscheme plugins configured (catppuccin, rose-pine, kanagawa, etc.)
- Blink.cmp for completion with Copilot integration
- Roslyn.nvim for C# development
- Custom LSP configurations for sourcekit (Swift)

## Common Commands

### Code Formatting
```bash
# Format Lua files using stylua (configured in stylua.toml)
stylua lua/
```

### Plugin Management
```vim
:Lazy              " Open lazy.nvim UI
:Lazy sync         " Update all plugins
:Lazy install      " Install missing plugins
:Lazy update       " Update plugins
:Lazy clean        " Remove unused plugins
```

### Health Check
```vim
:checkhealth       " Check Neovim and plugin health
:checkhealth lazy  " Check lazy.nvim specifically
```

## Development Notes

- When adding new plugins, create a new file in `lua/plugins/` that returns a plugin specification
- LazyVim extras can be added to `lazyvim.json` under the "extras" array
- The configuration uses LazyVim defaults with custom overrides
- Plugins are not lazy-loaded by default (see `defaults.lazy = false` in lazy.lua)