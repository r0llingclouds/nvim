-- Python: virtualenv selection for AI/ML work.
-- Detects .venv / poetry / uv / conda, restarts basedpyright with the chosen
-- interpreter, and feeds the interpreter to nvim-dap-python.

return {
  'linux-cultist/venv-selector.nvim',
  branch = 'main', -- the old `regexp` branch was merged into main (2025-08)
  dependencies = {
    'neovim/nvim-lspconfig',
    'nvim-telescope/telescope.nvim',
    'mfussenegger/nvim-dap-python',
  },
  ft = 'python',
  keys = {
    { '<leader>vs', '<cmd>VenvSelect<cr>', desc = '[V]env [S]elect' },
  },
  opts = {
    settings = {
      search = {
        my_venvs = { name = '*' },
      },
    },
  },
}
