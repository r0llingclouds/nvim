return {
  "folke/noice.nvim",
  opts = {
    lsp = {
      progress = {
        enabled = true,
        -- Filter out Roslyn progress messages
        format_done = "lsp_progress",
        throttle = 1000 / 30,
        view = "mini",
      },
    },
    routes = {
      -- Hide Roslyn progress notifications
      {
        filter = {
          event = "lsp",
          kind = "progress",
          cond = function(message)
            local client = message.opts and message.opts.progress and message.opts.progress.client
            return client == "roslyn"
          end,
        },
        opts = { skip = true },
      },
      -- Alternative: filter by content
      {
        filter = {
          event = "lsp",
          any = {
            { find = "Processing roslyn" },
            { find = "roslyn" },
          },
        },
        opts = { skip = true },
      },
    },
  },
  config = function(_, opts)
    local noice = require("noice")
    
    -- Patch the progress handler to handle nil values from Roslyn
    local progress_module = require("noice.lsp.progress")
    local original_progress = progress_module.progress
    
    progress_module.progress = function(data)
      -- Ensure data structure is valid
      if not data then
        return
      end
      
      data.params = data.params or {}
      data.params.token = data.params.token or "roslyn_" .. tostring(math.random(10000))
      
      -- Ensure value exists with proper structure
      if not data.params.value then
        data.params.value = {
          kind = "begin",
          title = "Processing",
          message = "",
          percentage = nil,
        }
      elseif type(data.params.value) ~= "table" then
        data.params.value = {
          kind = "begin",
          title = tostring(data.params.value),
          message = "",
          percentage = nil,
        }
      end
      
      -- Call original with validated data
      return original_progress(data)
    end
    
    noice.setup(opts)
  end,
}