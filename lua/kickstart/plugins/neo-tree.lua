-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim
-- Configured as BACKUP explorer (primary is Snacks.explorer)

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '<leader>E', ':Neotree toggle<CR>', desc = 'Explorer (Neo-tree)', silent = true },
  },
  opts = {
    close_if_last_window = true,
    window = {
      position = 'left',
      width = 30,
      mappings = {
        ['<leader>E'] = 'close_window',
      },
    },
    filesystem = {
      follow_current_file = { enabled = true },
      use_libuv_file_watcher = true,
      hijack_netrw_behavior = 'disabled',
      filtered_items = {
        hide_dotfiles = false,
        hide_by_name = { '.git', 'node_modules' },
        never_show = { '.DS_Store' },
      },
    },
    default_component_configs = {
      git_status = {
        symbols = {
          added = '+',
          modified = '~',
          deleted = '-',
          untracked = '?',
          ignored = '◌',
          unstaged = '✗',
          staged = '✓',
        },
      },
    },
  },
}
