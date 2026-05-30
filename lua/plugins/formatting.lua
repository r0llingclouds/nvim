-- Code Formatting
-- conform.nvim for format on save and manual formatting

return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>f',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = '',
      desc = '[F]ormat buffer',
    },
    {
      '<leader>uf',
      function()
        vim.g.disable_autoformat = not vim.g.disable_autoformat
        vim.notify('Format on save (global): ' .. (vim.g.disable_autoformat and 'OFF' or 'ON'))
      end,
      desc = 'Toggle format-on-save (global)',
    },
    {
      '<leader>uF',
      function()
        vim.b.disable_autoformat = not vim.b.disable_autoformat
        vim.notify('Format on save (buffer): ' .. (vim.b.disable_autoformat and 'OFF' or 'ON'))
      end,
      desc = 'Toggle format-on-save (buffer)',
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- Allow a global / per-buffer kill switch (see <leader>uf / <leader>uF).
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return nil
      end
      -- markdown is manual-only (<leader>f) so prettier never reflows vault notes.
      local disable_filetypes = { c = true, cpp = true, markdown = true }
      if disable_filetypes[vim.bo[bufnr].filetype] then
        return nil
      end
      -- Large Unity C# files occasionally need more time than the 500ms default.
      local timeout = vim.bo[bufnr].filetype == 'cs' and 2000 or 500
      return { timeout_ms = timeout, lsp_format = 'fallback' }
    end,
    formatters_by_ft = {
      lua = { 'stylua' },
      cs = { 'csharpier' },
      -- Python: fix → organize imports → format (deterministic save-time cleanup).
      python = { 'ruff_fix', 'ruff_organize_imports', 'ruff_format' },
      javascript = { 'prettierd' },
      typescript = { 'prettierd' },
      javascriptreact = { 'prettierd' },
      typescriptreact = { 'prettierd' },
      json = { 'prettierd' },
      jsonc = { 'prettierd' },
      css = { 'prettierd' },
      scss = { 'prettierd' },
      html = { 'prettierd' },
      yaml = { 'prettierd' },
      markdown = { 'prettierd' }, -- manual-only via the disable list above
      toml = { 'taplo' },
      swift = { 'swiftformat' }, -- requires: brew install swiftformat
    },
  },
}
