-- ~/.config/nvim/lua/plugins/copilot.lua
return {
  {
    "github/copilot.vim",
    event = "InsertEnter",
    config = function()
      -- Use a different key for Copilot since Tab conflicts with blink.cmp
      vim.g.copilot_no_tab_map = true

      -- Use Ctrl+L to accept Copilot suggestions (changed from Ctrl+J)
      vim.keymap.set("i", "<C-L>", 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false,
      })

      -- Optional: other useful mappings
      vim.keymap.set("i", "<C-]>", "<Plug>(copilot-next)")
      vim.keymap.set("i", "<C-[>", "<Plug>(copilot-previous)")
    end,
  },
}
