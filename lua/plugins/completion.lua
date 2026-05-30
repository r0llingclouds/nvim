-- Autocompletion
-- blink.cmp with LuaSnip integration

return {
  'saghen/blink.cmp',
  event = 'VimEnter',
  version = '1.*',
  dependencies = {
    -- Snippet Engine
    {
      'L3MON4D3/LuaSnip',
      version = '2.*',
      build = (function()
        if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
          return
        end
        return 'make install_jsregexp'
      end)(),
      opts = {},
    },
    'folke/lazydev.nvim',
    -- Completion for avante's @mentions / commands without pulling in nvim-cmp.
    'Kaiser-Yang/blink-cmp-avante',
  },
  --- @module 'blink.cmp'
  --- @type blink.cmp.Config
  opts = {
    keymap = {
      preset = 'enter',
      ['<C-j>'] = { 'select_next', 'fallback' },
      ['<C-k>'] = { 'select_prev', 'fallback' },
    },

    appearance = {
      nerd_font_variant = 'mono',
    },

    completion = {
      documentation = { auto_show = false, auto_show_delay_ms = 500 },
    },

    sources = {
      default = { 'lsp', 'path', 'snippets', 'lazydev', 'avante' },
      providers = {
        lazydev = { module = 'lazydev.integrations.blink', score_offset = 100 },
        avante = { module = 'blink-cmp-avante', name = 'Avante' },
      },
    },

    snippets = { preset = 'luasnip' },

    -- Prefer the prebuilt Rust fuzzy matcher (auto-downloaded for the v1.* tag on
    -- Apple Silicon; no cargo needed). Falls back to Lua if the binary is missing.
    fuzzy = { implementation = 'prefer_rust' },

    signature = { enabled = true },
  },
}
