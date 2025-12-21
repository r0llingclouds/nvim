-- Colorschemes: all themes consolidated

return {
  -- Tokyonight
  {
    'folke/tokyonight.nvim',
    lazy = true,
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('tokyonight').setup {
        styles = {
          comments = { italic = false },
        },
      }
    end,
  },

  -- Monokai Pro
  {
    'loctvl842/monokai-pro.nvim',
    lazy = true,
    opts = {
      transparent_background = false,
      terminal_colors = true,
      devicons = true,
      filter = 'pro', -- classic | octagon | pro | machine | ristretto | spectrum
      inc_search = 'background',
      background_clear = {
        'toggleterm',
        'telescope',
        'nvim-tree',
        'neo-tree',
      },
      plugins = {
        bufferline = {
          underline_selected = false,
          underline_visible = false,
        },
        indent_blankline = {
          context_highlight = 'default',
          context_start_underline = false,
        },
      },
    },
  },

  -- Dracula (default)
  {
    'Mofiqul/dracula.nvim',
    priority = 1000,
    config = function()
      vim.cmd.colorscheme 'dracula'
    end,
  },
  { 'catppuccin/nvim', name = 'catppuccin', lazy = true },
  { 'rebelot/kanagawa.nvim', lazy = true },
  { 'zenbones-theme/zenbones.nvim', dependencies = { 'rktjmp/lush.nvim' }, lazy = true },
  { 'neanias/everforest-nvim', lazy = true },
}
