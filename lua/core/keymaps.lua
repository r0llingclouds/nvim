-- Core keymaps (non-plugin)
-- See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Buffer switching
vim.keymap.set('n', '<leader>bD', '<cmd>:bd<cr>', { desc = 'Delete Buffer and Window' })
vim.keymap.set('n', '<leader>bb', '<cmd>e #<cr>', { desc = 'Switch to Other Buffer' })
vim.keymap.set('n', '<leader>`', '<cmd>e #<cr>', { desc = 'Switch to Other Buffer' })

-- Window resizing (Ctrl+arrows)
vim.keymap.set('n', '<C-Up>', '<cmd>resize +2<cr>', { desc = 'Increase Window Height' })
vim.keymap.set('n', '<C-Down>', '<cmd>resize -2<cr>', { desc = 'Decrease Window Height' })
vim.keymap.set('n', '<C-Left>', '<cmd>vertical resize -2<cr>', { desc = 'Decrease Window Width' })
vim.keymap.set('n', '<C-Right>', '<cmd>vertical resize +2<cr>', { desc = 'Increase Window Width' })

-- Search and replace
-- <leader>r : blank substitute — you type both target and replacement (cursor starts in the pattern field)
vim.keymap.set('n', '<leader>r', [[:%s///g<Left><Left><Left>]], { desc = '[R]eplace (type target/replacement)' })

-- <leader>R : prefill the target automatically, cursor lands in the replacement field.
--   normal mode -> word under the cursor, or the single symbol if it's not a word (e.g. *)
--   visual mode -> the selected text
-- Then type the replacement, or just <CR> to delete every match.
local function replace_prefill(target)
  local pat = vim.fn.escape(target, [[/\]]) -- \V = very nomagic, so * . etc. stay literal
  pat = pat:gsub('\n', [[\n]]) -- keep multi-line selections on a single cmdline
  local keys = [[:%s/\V]] .. pat .. [[//g<Left><Left>]]
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), 'n', false)
end

vim.keymap.set('n', '<leader>R', function()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] -- 0-indexed byte column
  local ch = line:sub(col + 1, col + 1)
  replace_prefill(ch:match '[%w_]' and vim.fn.expand '<cword>' or ch)
end, { desc = '[R]eplace target under cursor' })

vim.keymap.set('x', '<leader>R', function()
  vim.cmd 'noautocmd normal! "zy' -- yank selection into register z
  replace_prefill(vim.fn.getreg 'z')
end, { desc = '[R]eplace selected text' })
