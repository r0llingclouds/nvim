---@diagnostic disable: undefined-global

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
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    dashboard = {
      preset = {
        header = [[
                                                                             
               ████ ██████           █████      ██                     
              ███████████             █████                             
              █████████ ███████████████████ ███   ███████████   
             █████████  ███    █████████████ █████ ██████████████   
            █████████ ██████████ █████████ █████ █████ ████ █████   
          ███████████ ███    ███ █████████ █████ █████ ████ █████  
         ██████  █████████████████████ ████ █████ █████ ████ ██████ 
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
      replace_netrw = false,  -- Don't auto-open when opening directories
    },
    picker = { enabled = true },
    quickfile = { enabled = true },
    bufdelete = { enabled = true },
    dim = { enabled = true },
    scroll = { enabled = true },
  },
  keys = {
    {
      '<leader>e',
      function()
        Snacks.explorer()
      end,
      desc = 'Explorer',
    },
    {
      '<leader>bd',
      function()
        Snacks.bufdelete()
      end,
      desc = 'Delete Buffer',
    },
    {
      '<leader>bo',
      function()
        Snacks.bufdelete.other()
      end,
      desc = 'Delete Other Buffers',
    },
    {
      '<leader>bz',
      toggle_zen,
      desc = 'Toggle Zen Mode',
    },
  },
}
