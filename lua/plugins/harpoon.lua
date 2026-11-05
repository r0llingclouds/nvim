-- Harpoon: quick file list. Loads on the first <leader>m keypress.

-- Returns a function that calls harpoon:list():<method>(...).
local function on_list(method, ...)
  local args = { ... }
  return function()
    local list = require('harpoon'):list()
    list[method](list, unpack(args))
  end
end

local function toggle_menu()
  local harpoon = require 'harpoon'
  harpoon.ui:toggle_quick_menu(harpoon:list())
end

return {
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('harpoon'):setup()
    end,
    keys = {
      { '<leader>ma', on_list 'add', desc = 'Harpoon add file' },
      { '<leader>mm', toggle_menu, desc = 'Harpoon menu' },
      { '<leader>m1', on_list('select', 1), desc = 'Harpoon file 1' },
      { '<leader>m2', on_list('select', 2), desc = 'Harpoon file 2' },
      { '<leader>m3', on_list('select', 3), desc = 'Harpoon file 3' },
      { '<leader>m4', on_list('select', 4), desc = 'Harpoon file 4' },
      { '<leader>mp', on_list 'prev', desc = 'Harpoon previous' },
      { '<leader>mn', on_list 'next', desc = 'Harpoon next' },
    },
  },
}
