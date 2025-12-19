return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    -- Enable explorer module
    explorer = { enabled = true },
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
          { icon = ' ', key = 'e', desc = 'Explorer', action = function() Snacks.explorer() end },
          { icon = ' ', key = 'f', desc = 'Find File', action = ':Telescope find_files' },
          { icon = ' ', key = 'n', desc = 'New File', action = ':ene | startinsert' },
          { icon = ' ', key = 'g', desc = 'Find Text', action = ':Telescope live_grep' },
          { icon = ' ', key = 'r', desc = 'Recent Files', action = ':Telescope oldfiles' },
          { icon = '󰒲 ', key = 'l', desc = 'Lazy', action = ':Lazy' },
          { icon = ' ', key = 'q', desc = 'Quit', action = ':qa' },
        },
      },
    },
  },
  keys = {
    { '<leader>e', function() Snacks.explorer() end, desc = 'Explorer (Snacks)' },
  },
  config = function(_, opts)
    require('snacks').setup(opts)

    -- Show dashboard when opening a directory (e.g., nvim .)
    vim.api.nvim_create_autocmd('VimEnter', {
      callback = function()
        local arg = vim.fn.argv(0)
        if arg ~= '' and vim.fn.isdirectory(arg) == 1 then
          vim.cmd('bdelete')
          require('snacks').dashboard()
        end
      end,
    })

    -- Close dashboard when opening a file
    vim.api.nvim_create_autocmd('BufEnter', {
      callback = function()
        local buftype = vim.bo.buftype
        local filetype = vim.bo.filetype
        -- Skip special buffers (dashboard, explorer, etc.)
        if buftype ~= '' or filetype == 'snacks_dashboard' or filetype == 'snacks_picker_list' then
          return
        end
        -- Close any dashboard buffers when entering a real file
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_valid(buf) then
            local ft = vim.bo[buf].filetype
            if ft == 'snacks_dashboard' then
              vim.api.nvim_buf_delete(buf, { force = true })
            end
          end
        end
      end,
    })
  end,
}
