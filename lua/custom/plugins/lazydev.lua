-- Lua LSP enhancement for Neovim config development
-- Configures Lua LSP for completion, annotations and signatures of Neovim APIs

return {
  'folke/lazydev.nvim',
  ft = 'lua',
  opts = {
    library = {
      -- Load luvit types when the `vim.uv` word is found
      { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
    },
  },
}
