-- .NET build / run / test integration (roslyn.nvim owns the LSP layer).

return {
  'GustavEikaas/easy-dotnet.nvim',
  dependencies = { 'nvim-lua/plenary.nvim' },
  ft = 'cs',
  config = function()
    require('easy-dotnet').setup()
  end,
  keys = {
    { '<leader>nb', '<cmd>Dotnet build<cr>', desc = '.NET build' },
    { '<leader>nt', '<cmd>Dotnet test<cr>', desc = '.NET test' },
    { '<leader>nr', '<cmd>Dotnet run<cr>', desc = '.NET run' },
  },
}
