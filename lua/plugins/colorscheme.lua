-- Colorschemes: all themes consolidated

-- hardhat.nvim never sets vim.g.colors_name (its colors/*.vim just call
-- require('hardhat').start(...), and the loader does a `highlight clear`).
-- Things that read it — the transparency toggle in ui.lua, the Snacks
-- colorscheme picker — would otherwise see nil. Set it ourselves.
vim.api.nvim_create_autocmd('ColorScheme', {
  pattern = 'hardhat*',
  callback = function(ev)
    vim.g.colors_name = ev.match
  end,
})

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
  { 'ellisonleao/gruvbox.nvim', lazy = true, config = true, opts = {} },
  { 'oskarnurm/koda.nvim', lazy = true },
  { 'maxmx03/solarized.nvim', lazy = true },
  -- Hardhat: variants hardhat, hardhat-vivid, hardhat-diffused, hardhat-light, hardhat-m1
  {
    'g-kirti/hardhat.nvim',
    lazy = true,
    config = function()
      require('hardhat').setup {
        styles = {
          italic_comments = false,
        },
      }
    end,
  },
}
