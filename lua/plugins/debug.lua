-- Debug Adapter Protocol (DAP)
-- Python (debugpy), .NET/Unity (netcoredbg + nvim-dap-unity), Swift/native (codelldb).

return {
  'mfussenegger/nvim-dap',
  dependencies = {
    'rcarriga/nvim-dap-ui',
    'nvim-neotest/nvim-nio',
    'mason-org/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Language-specific adapters
    'mfussenegger/nvim-dap-python', -- Python
    'ownself/nvim-dap-unity', -- attach to the Unity editor/player
  },
  keys = {
    { '<F5>', function() require('dap').continue() end, desc = 'Debug: Start/Continue' },
    { '<F1>', function() require('dap').step_into() end, desc = 'Debug: Step Into' },
    { '<F2>', function() require('dap').step_over() end, desc = 'Debug: Step Over' },
    { '<F3>', function() require('dap').step_out() end, desc = 'Debug: Step Out' },
    { '<leader>db', function() require('dap').toggle_breakpoint() end, desc = 'Debug: Toggle Breakpoint' },
    { '<leader>dB', function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end, desc = 'Debug: Set Breakpoint' },
    { '<F7>', function() require('dapui').toggle() end, desc = 'Debug: See last session result' },
  },
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      automatic_installation = true,
      -- Default handler wires dap.adapters/configurations for installed adapters.
      handlers = {
        function(config)
          require('mason-nvim-dap').default_setup(config)
        end,
      },
      ensure_installed = {
        'python', -- debugpy
        'netcoredbg', -- .NET / Unity (C#)
        'codelldb', -- Swift / native (used by xcodebuild.nvim too)
      },
    }

    dapui.setup {
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Python: point debugpy at Mason's own venv interpreter (not system python3).
    require('dap-python').setup(vim.fn.stdpath 'data' .. '/mason/packages/debugpy/venv/bin/python')

    -- Unity: <F5> on a .cs buffer offers "Attach to Unity" (start Play mode first).
    pcall(function()
      require('nvim-dap-unity').setup { auto_setup_dap = true }
    end)
  end,
}
