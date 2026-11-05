-- Fuzzy Finder (files, lsp, etc). Loads on first use.

local function builtin(name, opts)
  return function()
    require('telescope.builtin')[name](type(opts) == 'function' and opts() or opts)
  end
end

return {
  'nvim-telescope/telescope.nvim',
  cmd = 'Telescope',
  dependencies = {
    'nvim-lua/plenary.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
      cond = function()
        return vim.fn.executable 'make' == 1
      end,
    },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
  },
  init = function()
    -- The first vim.ui.select call (code actions, etc.) loads telescope so
    -- telescope-ui-select handles it. Falls back to the default list if the
    -- extension didn't register.
    local default_select = vim.ui.select
    local function lazy_select(...)
      require('lazy').load { plugins = { 'telescope.nvim' } }
      if vim.ui.select == lazy_select then
        vim.ui.select = default_select
      end
      return vim.ui.select(...)
    end
    vim.ui.select = lazy_select
  end,
  -- See `:help telescope.builtin`
  keys = {
    { '<leader>sh', builtin 'help_tags', desc = '[S]earch [H]elp' },
    { '<leader>sk', builtin 'keymaps', desc = '[S]earch [K]eymaps' },
    { '<leader>ss', builtin 'builtin', desc = '[S]earch [S]elect Telescope' },
    { '<leader>sw', builtin 'grep_string', desc = '[S]earch current [W]ord' },
    { '<leader>sg', builtin 'live_grep', desc = '[S]earch by [G]rep' },
    { '<leader>sd', builtin 'diagnostics', desc = '[S]earch [D]iagnostics' },
    { '<leader>sr', builtin 'resume', desc = '[S]earch [R]esume' },
    { '<leader>s.', builtin 'oldfiles', desc = '[S]earch Recent Files ("." for repeat)' },
    { '<leader><leader>', builtin 'find_files', desc = '[ ] Find project files' },
    {
      '<leader>/',
      builtin('current_buffer_fuzzy_find', function()
        return require('telescope.themes').get_dropdown { winblend = 10, previewer = false }
      end),
      desc = '[/] Fuzzily search in current buffer',
    },
    {
      '<leader>s/',
      builtin('live_grep', { grep_open_files = true, prompt_title = 'Live Grep in Open Files' }),
      desc = '[S]earch [/] in Open Files',
    },
  },
  config = function()
    require('telescope').setup {
      defaults = {
        mappings = {
          i = {
            ['<C-j>'] = 'move_selection_next',
            ['<C-k>'] = 'move_selection_previous',
          },
        },
      },
      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    }

    -- Enable Telescope extensions if they are installed
    pcall(require('telescope').load_extension, 'fzf')
    pcall(require('telescope').load_extension, 'ui-select')
  end,
}
