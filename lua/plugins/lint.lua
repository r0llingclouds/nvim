-- Linting with nvim-lint
-- Python is handled by the Ruff LSP (see lsp.lua); C# by roslyn. This covers the rest.

return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    local lint = require 'lint'

    lint.linters_by_ft = {
      javascript = { 'eslint_d' },
      javascriptreact = { 'eslint_d' },
      typescript = { 'eslint_d' },
      typescriptreact = { 'eslint_d' },
      markdown = { 'markdownlint' },
    }

    -- swiftlint isn't a Mason package — only wire it when the binary is on PATH.
    if vim.fn.executable 'swiftlint' == 1 then
      lint.linters_by_ft.swift = { 'swiftlint' }
    end

    -- Filetypes that have a linter configured but should NOT lint automatically.
    -- markdownlint is noisy for prose/notes, so it's off by default — run it on
    -- demand with <leader>ul.
    local no_autolint = {
      markdown = true,
    }

    -- Create autocommand which carries out the actual linting
    local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
    vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
      group = lint_augroup,
      callback = function()
        -- Only run the linter in buffers that you can modify, and skip
        -- filetypes we've opted out of automatic linting.
        if vim.bo.modifiable and not no_autolint[vim.bo.filetype] then
          lint.try_lint()
        end
      end,
    })

    vim.keymap.set('n', '<leader>ul', function()
      lint.try_lint()
    end, { desc = 'Trigger [l]inting for current buffer' })
  end,
}
