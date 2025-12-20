---@diagnostic disable: undefined-global
-- UI plugins: snacks, bufferline, noice

-- Custom zen mode state
local zen_active = false
local zen_saved = {}

local function toggle_zen()
  zen_active = not zen_active

  if zen_active then
    -- Save current settings
    zen_saved.number = vim.wo.number
    zen_saved.relativenumber = vim.wo.relativenumber
    zen_saved.signcolumn = vim.wo.signcolumn
    zen_saved.diagnostics = vim.diagnostic.is_enabled()
    zen_saved.laststatus = vim.o.laststatus
    zen_saved.showtabline = vim.o.showtabline

    -- Apply zen settings
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.signcolumn = 'no'
    vim.o.laststatus = 0
    vim.o.showtabline = 0
    vim.diagnostic.enable(false)

    -- Disable gitsigns if available
    local gs_ok, gitsigns = pcall(require, 'gitsigns')
    if gs_ok then
      zen_saved.gitsigns = true
      gitsigns.toggle_signs(false)
    end

    -- Enable dim
    Snacks.dim.enable()
  else
    -- Restore saved settings
    vim.wo.number = zen_saved.number
    vim.wo.relativenumber = zen_saved.relativenumber
    vim.wo.signcolumn = zen_saved.signcolumn
    vim.o.laststatus = zen_saved.laststatus
    vim.o.showtabline = zen_saved.showtabline
    if zen_saved.diagnostics then
      vim.diagnostic.enable(true)
    end

    -- Restore gitsigns
    if zen_saved.gitsigns then
      local gs_ok, gitsigns = pcall(require, 'gitsigns')
      if gs_ok then
        gitsigns.toggle_signs(true)
      end
    end

    -- Disable dim
    Snacks.dim.disable()
  end
end

return {
  -- Snacks: dashboard, explorer, picker, zen mode
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      dashboard = {
        preset = {
          header = [[

               ████ ██████           █████      ██
              ███████████             █████
              █████████ ███████████████████ ███   ███████████
             █████████  ███    █████████████ █████ ██████████████
            █████████ ██████████ █████████ █████ █████ ████ █████
          ███████████ ███    ███ █████████ █████ █████ ████ █████
         ██████  █████████████████████ ████ █████ █████ ████ ██████
      ]],
          keys = {
            { icon = ' ', key = 'e', desc = 'Explorer', action = ':lua Snacks.explorer({ cwd = vim.fn.getcwd() })' },
            { icon = ' ', key = 'f', desc = 'Find File', action = ":lua Snacks.dashboard.pick('files')" },
            { icon = ' ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
            { icon = ' ', key = 'g', desc = 'Find Text', action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = ' ', key = 'r', desc = 'Recent Files', action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = '󰒲 ', key = 'l', desc = 'Lazy', action = ':Lazy' },
            { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
          },
        },
      },
      explorer = {
        enabled = true,
        replace_netrw = false,
      },
      picker = { enabled = true },
      quickfile = { enabled = true },
      bufdelete = { enabled = true },
      dim = { enabled = true },
      scroll = { enabled = true },
    },
    keys = {
      { '<leader>e', function() Snacks.explorer() end, desc = 'Explorer' },
      { '<leader>bd', function() Snacks.bufdelete() end, desc = 'Delete Buffer' },
      { '<leader>bo', function() Snacks.bufdelete.other() end, desc = 'Delete Other Buffers' },
      { '<leader>bz', toggle_zen, desc = 'Toggle Zen Mode' },
      { '<leader>uc', function() Snacks.picker.colorschemes() end, desc = 'Colorschemes' },
      { '<leader>ud', function() vim.o.background = vim.o.background == 'dark' and 'light' or 'dark' end, desc = 'Toggle Light/Dark' },
    },
  },

  -- Bufferline: buffer tabs
  {
    'akinsho/bufferline.nvim',
    version = '*',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    event = 'VeryLazy',
    opts = {
      options = {
        mode = 'buffers',
        numbers = 'none',
        close_command = 'bdelete! %d',
        indicator = { style = 'icon', icon = '▎' },
        buffer_close_icon = '󰅖',
        modified_icon = '●',
        close_icon = '',
        left_trunc_marker = '',
        right_trunc_marker = '',
        max_name_length = 18,
        max_prefix_length = 15,
        truncate_names = true,
        tab_size = 18,
        diagnostics = 'nvim_lsp',
        diagnostics_update_in_insert = false,
        offsets = {
          {
            filetype = 'snacks_picker_list',
            text = 'Explorer',
            highlight = 'Directory',
            separator = true,
          },
        },
        show_buffer_icons = true,
        show_buffer_close_icons = true,
        show_close_icon = false,
        show_tab_indicators = true,
        separator_style = 'thin',
        always_show_bufferline = true,
        hover = { enabled = true, delay = 200, reveal = { 'close' } },
      },
    },
    keys = {
      { '<S-h>', '<cmd>BufferLineCyclePrev<cr>', desc = 'Prev buffer' },
      { '<S-l>', '<cmd>BufferLineCycleNext<cr>', desc = 'Next buffer' },
      { '<leader>bp', '<cmd>BufferLineTogglePin<cr>', desc = 'Pin buffer' },
      { '<leader>bP', '<cmd>BufferLineGroupClose ungrouped<cr>', desc = 'Close unpinned' },
      { '<leader>bl', '<cmd>BufferLineCloseRight<cr>', desc = 'Close right' },
      { '<leader>bh', '<cmd>BufferLineCloseLeft<cr>', desc = 'Close left' },
    },
  },

  -- Noice: replaces Neovim UI for messages, cmdline, and popups
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
      'MunifTanjim/nui.nvim',
      'rcarriga/nvim-notify',
    },
    opts = {
      lsp = {
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true,
        },
      },
      presets = {
        bottom_search = false,
        command_palette = true,
        long_message_to_split = true,
        lsp_doc_border = true,
      },
    },
  },
}
