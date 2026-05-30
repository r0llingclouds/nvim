-- Test runner: neotest with Python (pytest) + .NET adapters.
-- `<leader>td` reuses nvim-dap-python to debug the nearest test.

return {
  'nvim-neotest/neotest',
  dependencies = {
    'nvim-neotest/nvim-nio',
    'nvim-lua/plenary.nvim',
    'antoinemadec/FixCursorHold.nvim',
    'nvim-neotest/neotest-python',
    'Issafalcon/neotest-dotnet',
  },
  keys = {
    { '<leader>tt', function() require('neotest').run.run() end, desc = 'Test: nearest' },
    { '<leader>tf', function() require('neotest').run.run(vim.fn.expand '%') end, desc = 'Test: file' },
    { '<leader>ts', function() require('neotest').summary.toggle() end, desc = 'Test: summary' },
    { '<leader>to', function() require('neotest').output.open { enter = true } end, desc = 'Test: output' },
    { '<leader>td', function() require('neotest').run.run { strategy = 'dap' } end, desc = 'Test: debug nearest' },
  },
  config = function()
    require('neotest').setup {
      adapters = {
        require 'neotest-python' { dap = { justMyCode = false } },
        require 'neotest-dotnet',
      },
    }
  end,
}
