-- Indent scope highlighting
-- Uses mini.indentscope for current scope, indent-blankline for guides

return {
  -- Animate and highlight current scope
  {
    'echasnovski/mini.indentscope',
    version = false,
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      symbol = '│',
      options = { try_as_border = true },
    },
    init = function()
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'help', 'dashboard', 'neo-tree', 'Trouble', 'lazy', 'mason', 'notify', 'snacks_dashboard' },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    end,
  },

  -- Static indent guides
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      indent = { char = '│' },
      scope = { enabled = false }, -- Use mini.indentscope instead
      exclude = {
        filetypes = { 'help', 'dashboard', 'neo-tree', 'Trouble', 'lazy', 'mason', 'notify', 'snacks_dashboard' },
      },
    },
  },
}
