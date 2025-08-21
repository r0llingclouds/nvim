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
  },
}