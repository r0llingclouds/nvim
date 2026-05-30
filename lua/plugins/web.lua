-- Web / blog stack (Next.js + React + Tailwind).
-- LSP servers (vtsls, tailwindcss, cssls, html, emmet) live in lsp.lua;
-- these are the editing-experience plugins.

return {
  -- Auto-close / auto-rename JSX/HTML tags.
  {
    'windwp/nvim-ts-autotag',
    ft = { 'html', 'xml', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'svelte', 'astro', 'markdown' },
    opts = {},
  },

  -- Correct `{/* */}` comments inside JSX via the built-in commenting.
  {
    'JoosepAlviste/nvim-ts-context-commentstring',
    lazy = true,
    init = function()
      vim.g.skip_ts_context_commentstring_module = true
    end,
    config = function()
      require('ts_context_commentstring').setup { enable_autocmd = false }
      local get_option = vim.filetype.get_option
      vim.filetype.get_option = function(filetype, option)
        return option == 'commentstring'
            and require('ts_context_commentstring.internal').calculate_commentstring()
          or get_option(filetype, option)
      end
    end,
  },

  -- Inline npm version / outdated info in package.json.
  {
    'vuki656/package-info.nvim',
    dependencies = { 'MunifTanjim/nui.nvim' },
    ft = 'json',
    opts = { package_manager = 'npm' },
  },

  -- Color swatches for Tailwind/CSS classes and hex values.
  {
    'brenoprata10/nvim-highlight-colors',
    ft = { 'css', 'scss', 'html', 'javascriptreact', 'typescriptreact', 'svelte', 'astro' },
    opts = { render = 'background', enable_tailwind = true },
  },
}
