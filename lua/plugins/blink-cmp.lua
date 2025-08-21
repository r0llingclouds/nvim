return {
  "saghen/blink.cmp",
  opts = {
    keymap = {
      preset = "default",
      -- Override the default keymaps to use Ctrl-j and Ctrl-k for navigation
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-k>"] = { "select_prev", "fallback" },
      -- Keep other useful keymaps
      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      ["<C-e>"] = { "cancel", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
      ["<Tab>"] = { "select_next", "fallback" },
      ["<S-Tab>"] = { "select_prev", "fallback" },
      -- Disable arrow keys for navigation (optional)
      ["<Up>"] = { "fallback" },
      ["<Down>"] = { "fallback" },
    },
    completion = {
      ghost_text = {
        enabled = true,
      },
    },
  },
  config = function(_, opts)
    -- Wrap blink.cmp setup to handle cmdline conflicts
    local blink = require("blink.cmp")
    
    -- Store original ghost text draw function
    local ghost_text = require("blink.cmp.completion.windows.ghost_text")
    local original_draw = ghost_text.draw_preview
    
    -- Override draw_preview to check for cmdline mode
    ghost_text.draw_preview = function(...)
      -- Skip drawing in cmdline mode or noice buffers
      if vim.fn.mode() == "c" then
        return
      end
      
      -- Check if we're in a special buffer that might cause issues
      local bufnr = vim.api.nvim_get_current_buf()
      local buftype = vim.api.nvim_buf_get_option(bufnr, "buftype")
      if buftype == "nofile" or buftype == "prompt" then
        return
      end
      
      -- Safe to draw
      local ok, result = pcall(original_draw, ...)
      if not ok then
        -- Silently ignore errors instead of crashing
        return
      end
      return result
    end
    
    blink.setup(opts)
  end,
}