-- ~/.config/nvim/lua/plugins/roslyn.lua
return {
  "seblyng/roslyn.nvim",
  ft = "cs",
  opts = {
    on_attach = function(client, bufnr)
      local bufopts = { noremap = true, silent = true, buffer = bufnr }

      -- Use Telescope for references instead of quickfix
      vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", bufopts)
    end,
  },
}
