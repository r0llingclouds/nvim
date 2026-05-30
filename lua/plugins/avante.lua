return {
  'yetone/avante.nvim',
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = vim.fn.has 'win32' ~= 0 and 'powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false' or 'make',
  -- Load on demand instead of every session (drops the eager startup cost).
  cmd = { 'AvanteAsk', 'AvanteToggle', 'AvanteEdit', 'AvanteChat', 'AvanteRefresh' },
  keys = {
    { '<leader>aa', '<cmd>AvanteToggle<cr>', desc = 'Avante: toggle' },
    { '<leader>ak', '<cmd>AvanteAsk<cr>', mode = { 'n', 'v' }, desc = 'Avante: ask' },
    { '<leader>ae', '<cmd>AvanteEdit<cr>', mode = 'v', desc = 'Avante: edit' },
    { '<leader>ar', '<cmd>AvanteRefresh<cr>', desc = 'Avante: refresh' },
  },
  version = false, -- Never set this value to "*"! Never!
  ---@module 'avante'
  ---@type avante.Config
  opts = {
    instructions_file = 'avante.md',
    provider = 'claude',
    providers = {
      claude = {
        endpoint = 'https://api.anthropic.com',
        model = 'claude-sonnet-4-5-20250929',
        timeout = 30000, -- Timeout in milliseconds
        extra_request_body = {
          temperature = 0.75,
          max_tokens = 20480,
        },
      },
      moonshot = {
        endpoint = 'https://api.moonshot.ai/v1',
        model = 'kimi-k2-0711-preview',
        timeout = 30000, -- Timeout in milliseconds
        extra_request_body = {
          temperature = 0.75,
          max_tokens = 32768,
        },
      },
    },
    -- Reuse already-loaded UIs instead of pulling extra picker/input engines.
    selector = { provider = 'telescope' },
    input = { provider = 'snacks' },
  },
  dependencies = {
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    'nvim-telescope/telescope.nvim', -- file selector
    'folke/snacks.nvim', -- input provider
    'nvim-tree/nvim-web-devicons',
    -- @mention / command completion is provided through blink (blink-cmp-avante,
    -- registered in completion.lua) — no nvim-cmp needed.
    {
      -- support for image pasting
      'HakonHarnes/img-clip.nvim',
      event = 'VeryLazy',
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { 'markdown', 'Avante' },
        -- Markdown opens un-rendered (plain treesitter highlighting); toggle on with <leader>tm.
        -- Avante's panel has no override, so it still renders via the global default.
        overrides = {
          filetype = {
            markdown = { enabled = false },
          },
        },
      },
      ft = { 'markdown', 'Avante' },
      keys = {
        { '<leader>tm', '<cmd>RenderMarkdown buf_toggle<cr>', desc = 'Toggle [M]arkdown render (buffer)' },
      },
    },
  },
}
