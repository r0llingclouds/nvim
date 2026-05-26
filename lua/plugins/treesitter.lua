-- Treesitter: Highlight, edit, and navigate code

return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  build = ':TSUpdate',
  config = function()
    -- main-branch API: install parsers explicitly (ensure_installed/auto_install no longer exist)
    require('nvim-treesitter').install { 'bash', 'c', 'diff', 'html', 'lua', 'luadoc', 'markdown', 'markdown_inline', 'query', 'vim', 'vimdoc' }

    -- main-branch API: highlighting is not automatic; start it per-buffer (replaces highlight = { enable = true })
    vim.api.nvim_create_autocmd('FileType', {
      callback = function(args)
        pcall(vim.treesitter.start, args.buf)
      end,
    })

    -- Additional vim regex highlighting for Ruby
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'ruby',
      callback = function()
        vim.opt_local.syntax = 'on'
      end,
    })
  end,
}
