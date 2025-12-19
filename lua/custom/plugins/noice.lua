-- Noice: Replaces Neovim UI for messages, cmdline, and popups
-- Provides floating command line, search, and notifications

return {
  'folke/noice.nvim',
  event = 'VeryLazy',
  dependencies = {
    'MunifTanjim/nui.nvim',
    'rcarriga/nvim-notify',
  },
  opts = {
    lsp = {
      -- Override markdown rendering so that blink.cmp and other plugins use Treesitter
      override = {
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        ['cmp.entry.get_documentation'] = true,
      },
    },
    presets = {
      bottom_search = false, -- use floating for search
      command_palette = true, -- floating cmdline at center
      long_message_to_split = true, -- long messages go to split
      lsp_doc_border = true, -- add border to hover docs
    },
  },
}
