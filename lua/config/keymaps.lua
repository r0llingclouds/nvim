-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--
-- Delete LazyVim's window navigation
-- vim.keymap.del("n", "<C-h>")
-- vim.keymap.del("n", "<C-j>")
-- vim.keymap.del("n", "<C-k>")
-- vim.keymap.del("n", "<C-l>")
-- vim.keymap.set("n", "<C-j>", "<C-d>", { desc = "Scroll down half page" })
-- vim.keymap.set("n", "<C-k>", "<C-u>", { desc = "Scroll up half page" })
-- vim.keymap.set("v", "<C-j>", "<C-d>", { desc = "Scroll down half page" })
-- vim.keymap.set("v", "<C-k>", "<C-u>", { desc = "Scroll up half page" })

vim.keymap.set("n", "<leader>rg", ":%s/<C-r><C-w>//g<Left><Left>", { desc = "Replace word under cursor globally" })
