-- Treesitter: Highlight, edit, and navigate code

return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  config = function()
    ---@diagnostic disable-next-line: missing-fields
    require('nvim-treesitter').setup {
      ensure_installed = { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' },
      auto_install = true,
    }

    -- Additional vim regex highlighting for Ruby
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'ruby',
      callback = function()
        vim.opt_local.syntax = 'on'
      end,
    })
  end,
}
