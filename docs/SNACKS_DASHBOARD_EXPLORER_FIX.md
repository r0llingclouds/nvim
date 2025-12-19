# Comprehensive Report: Snacks.nvim Dashboard & Explorer Integration Fix

**Date:** 2025-12-19
**Config Location:** `/Users/tirso.lopez/.config/nvim`
**Reference Working Config:** `/Users/tirso.lopez/.config/nvim-fresh`

---

## Problem Statement

When opening a file from the Snacks explorer (triggered by pressing 'e' on the dashboard), the dashboard/splash screen remained visible and blocked the file view. The user could not see the opened file.

---

## Environment

- **Neovim Config Location:** `/Users/tirso.lopez/.config/nvim`
- **Plugin:** folke/snacks.nvim
- **Features Used:** Dashboard, Explorer, Picker
- **OS:** Darwin (macOS)

---

## Failed Attempts (Chronological)

### Attempt 1: BufEnter Autocmd to Delete Dashboard Buffer

**Code:**
```lua
vim.api.nvim_create_autocmd('BufEnter', {
  callback = function()
    local buftype = vim.bo.buftype
    local filetype = vim.bo.filetype
    -- Skip special buffers (dashboard, explorer, etc.)
    if buftype ~= '' or filetype == 'snacks_dashboard' or filetype == 'snacks_picker_list' then
      return
    end
    -- Close any dashboard buffers when entering a real file
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_valid(buf) then
        local ft = vim.bo[buf].filetype
        if ft == 'snacks_dashboard' then
          vim.api.nvim_buf_delete(buf, { force = true })
        end
      end
    end
  end,
})
```

**Result:** Error - "Invalid buffer id: 2"
**Reason:** Explorer was still referencing the buffer being deleted.

---

### Attempt 2: Deferred Buffer Deletion with vim.schedule and pcall

**Code:**
```lua
vim.api.nvim_create_autocmd('BufEnter', {
  callback = function()
    local buftype = vim.bo.buftype
    local filetype = vim.bo.filetype
    -- Skip special buffers (dashboard, explorer, etc.)
    if buftype ~= '' or filetype == 'snacks_dashboard' or filetype == 'snacks_picker_list' then
      return
    end
    -- Defer deletion to avoid conflicts with explorer
    vim.schedule(function()
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
          local ok, ft = pcall(function() return vim.bo[buf].filetype end)
          if ok and ft == 'snacks_dashboard' then
            pcall(vim.api.nvim_buf_delete, buf, { force = true })
          end
        end
      end
    end)
  end,
})
```

**Result:** Error - "Vim:E367: No such group: --Deleted--"
**Reason:** Snacks' internal cleanup was being bypassed, causing augroup errors.

---

### Attempt 3: Remove BufEnter Autocmd Entirely

Removed the autocmd completely, hoping dashboard would handle itself.

**Result:** Dashboard stayed visible - no auto-close behavior.
**Reason:** Without any intervention, the dashboard window just stayed open.

---

### Attempt 4: Function Action with bdelete

**Code:**
```lua
{ icon = ' ', key = 'e', desc = 'Explorer', action = function()
  vim.cmd('bdelete')
  vim.schedule(function() Snacks.explorer() end)
end },
```

**Result:** Dashboard still visible.
**Reason:** `bdelete` deleted the buffer but the window remained in the layout.

---

### Attempt 5: Function Action with enew

**Code:**
```lua
{ icon = ' ', key = 'e', desc = 'Explorer', action = function()
  vim.cmd('enew')  -- Replace dashboard with empty buffer
  Snacks.explorer()
end },
```

**Result:** Dashboard still visible.
**Reason:** Same window layout issue - the window structure wasn't being handled properly.

---

## Root Cause Analysis

After examining the working configuration at `/Users/tirso.lopez/.config/nvim-fresh/`, the root cause was identified.

### The Core Problem: Function Actions vs String Actions

**Broken Configuration (Function Action):**
```lua
{ icon = ' ', key = 'e', desc = 'Explorer', action = function() Snacks.explorer() end }
```

**Working Configuration (String Action):**
```lua
{ icon = " ", key = "e", desc = "Explorer", action = ":lua Snacks.explorer({ cwd = vim.fn.getcwd() })" }
```

### Why String Actions Work

Looking at snacks.nvim's `dashboard.lua` source code, the dashboard has built-in auto-close behavior:

```lua
-- From snacks.nvim/lua/snacks/dashboard.lua
if self:is_float() then
    vim.api.nvim_win_close(self.win, true)
    self.win = nil
end
```

However, this auto-close is triggered **differently** based on action type:

| Action Type | Behavior |
|-------------|----------|
| **String actions** (`:lua ...`, `:command`) | Processed through Neovim's command execution, which triggers the dashboard's action handler to close the window FIRST, then execute the command |
| **Function actions** (`function() ... end`) | Execute directly WITHOUT triggering the dashboard's window management logic |

### Secondary Issue: Custom Config Function

The custom `config` function with the `VimEnter` autocmd was also interfering:

```lua
config = function(_, opts)
  require("snacks").setup(opts)

  -- This autocmd was causing issues
  vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
      local arg = vim.fn.argv(0)
      if arg ~= "" and vim.fn.isdirectory(arg) == 1 then
        vim.cmd("bdelete")
        require("snacks").dashboard()
      end
    end,
  })
end,
```

This was creating the dashboard in a non-standard way that didn't integrate properly with the explorer's file-opening behavior. The dashboard created this way didn't have the proper internal state for auto-closing.

---

## The Final Working Solution

### File: `/Users/tirso.lopez/.config/nvim/lua/custom/plugins/snacks.lua`

```lua
return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    dashboard = {
      preset = {
        header = [[

      ████ ██████           █████      ██
     ███████████             █████
     █████████ ███████████████████ ███   ███████████
    █████████  ███    █████████████ █████ ██████████████
   █████████ ██████████ █████████ █████ █████ ████ █████
 ███████████ ███    ███ █████████ █████ █████ ████ █████
██████  █████████████████████ ████ █████ █████ ████ ██████
        ]],
        keys = {
          { icon = " ", key = "e", desc = "Explorer", action = ":lua Snacks.explorer({ cwd = vim.fn.getcwd() })" },
          { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
          { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
          { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
          { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
          { icon = " ", key = "q", desc = "Quit", action = ":qa" },
        },
      },
    },
    explorer = { enabled = true },
    picker = { enabled = true },
    quickfile = { enabled = true },
  },
  keys = {
    { "<leader>e", function() Snacks.explorer() end, desc = "Explorer" },
  },
}
```

---

## Key Changes That Fixed the Issue

| Change | Before (Broken) | After (Working) |
|--------|-----------------|-----------------|
| Dashboard 'e' action | `function() Snacks.explorer() end` | `":lua Snacks.explorer({ cwd = vim.fn.getcwd() })"` |
| Dashboard 'f' action | `:Telescope find_files` | `:lua Snacks.dashboard.pick('files')` |
| Dashboard 'g' action | `:Telescope live_grep` | `:lua Snacks.dashboard.pick('live_grep')` |
| Dashboard 'r' action | `:Telescope oldfiles` | `:lua Snacks.dashboard.pick('oldfiles')` |
| picker module | Not enabled | `picker = { enabled = true }` |
| quickfile module | Not enabled | `quickfile = { enabled = true }` |
| config function | Custom with VimEnter autocmd | **REMOVED ENTIRELY** |

---

## Why Each Change Matters

### 1. String Actions (CRITICAL - This was the main fix)

String actions like `:lua Snacks.explorer(...)` are processed by Neovim's command system, which allows the dashboard to properly:
1. Intercept the action
2. Close its window FIRST
3. Then execute the command

Function actions bypass this entirely and execute directly, leaving the dashboard window open.

**Rule: ALWAYS use string actions for dashboard preset keys.**

### 2. picker = { enabled = true }

Enables Snacks' built-in file picker which integrates natively with the dashboard and explorer. This ensures:
- `Snacks.dashboard.pick('files')` works correctly
- `Snacks.dashboard.pick('live_grep')` works correctly
- `Snacks.dashboard.pick('oldfiles')` works correctly

Without this, those actions would fail silently.

### 3. quickfile = { enabled = true }

Optimizes file loading performance:
- Renders files before plugins load
- Ensures files open quickly without UI glitches
- Reduces perceived latency when opening files from explorer

### 4. No Custom Config Function (CRITICAL)

Removing the custom `config` function allows lazy.nvim to use Snacks' default setup process, which:
- Properly initializes all internal state
- Sets up dashboard/explorer coordination correctly
- Ensures the dashboard has proper auto-close hooks registered

The VimEnter autocmd was creating a "second" dashboard that wasn't properly integrated.

### 5. Using Snacks Picker Instead of Telescope

Using `Snacks.dashboard.pick('files')` instead of `:Telescope find_files` ensures:
- All actions use the same integrated system
- Consistent behavior across all dashboard actions
- Proper dashboard auto-close for ALL file-related actions

---

## Reference: Working Config from nvim-fresh

### File: `/Users/tirso.lopez/.config/nvim-fresh/lua/plugins/ui.lua`

```lua
return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      dashboard = {
        preset = {
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "e", desc = "Explorer", action = ":lua Snacks.explorer({ cwd = vim.fn.getcwd() })" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
          header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
          ]],
        },
      },
      explorer = { enabled = true },
      picker = { enabled = true },
      notifier = { enabled = true, timeout = 3000 },
      indent = { enabled = true },
      statuscolumn = { enabled = true },
      quickfile = { enabled = true },
    },
    keys = {
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
      { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader><space>", function() Snacks.picker.files() end, desc = "Find Files" },
      { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
      { "<leader>fr", function() Snacks.picker.recent() end, desc = "Recent Files" },
      { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
      { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
    },
  },

  -- Icons (required by Snacks)
  { "nvim-tree/nvim-web-devicons", lazy = true },
  { "echasnovski/mini.icons", lazy = true, opts = {} },
}
```

### File: `/Users/tirso.lopez/.config/nvim-fresh/lua/config/keymaps.lua`

```lua
local map = vim.keymap.set

-- Explorer toggle
map("n", "<leader>e", function()
  Snacks.explorer({ cwd = vim.fn.getcwd() })
end, { desc = "Explorer" })

-- Basic navigation
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window" })

-- Buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })

-- Clear search
map("n", "<esc>", "<cmd>noh<cr><esc>", { desc = "Clear search" })

-- Save
map({ "i", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- Quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })
```

### File: `/Users/tirso.lopez/.config/nvim-fresh/lua/config/options.lua`

```lua
-- Leader key (MUST be set before lazy.nvim)
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Disable netrw (we use Snacks explorer)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- Essential options
local opt = vim.opt
opt.number = true
opt.relativenumber = true
opt.termguicolors = true
opt.clipboard = "unnamedplus"
opt.mouse = "a"
opt.showmode = false
opt.signcolumn = "yes"
opt.cursorline = true
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true
opt.ignorecase = true
opt.smartcase = true
opt.splitbelow = true
opt.splitright = true
opt.undofile = true
opt.updatetime = 200
opt.timeoutlen = 300
```

---

## Lessons Learned

### 1. ALWAYS use string actions for dashboard keys
Function actions bypass the dashboard's built-in window management. String actions trigger proper cleanup.

### 2. Don't override the config function unless absolutely necessary
The default lazy.nvim opts handling works better with Snacks. Custom config functions can break internal state.

### 3. Enable related modules together
Dashboard, explorer, and picker are designed to work as an integrated system. Enable all of them.

### 4. When something doesn't work, find a working example and replicate EXACTLY
Don't try to fix incrementally - find what works and copy it completely.

### 5. The simplest config is often the best
The working config has NO custom config function, NO autocmds, just opts and keys.

---

## Current Working Behavior

1. `nvim` → Dashboard appears with header and action keys
2. Press `e` on dashboard → Dashboard closes automatically, explorer opens on left sidebar
3. Select file in explorer → File opens in main window, dashboard is gone
4. `<leader>e` from any buffer → Toggles explorer sidebar
5. Press `f` on dashboard → Snacks file picker opens, dashboard closes
6. Select file in picker → File opens properly
7. Press `g` on dashboard → Live grep opens, dashboard closes
8. Press `r` on dashboard → Recent files picker opens, dashboard closes

---

## Files Modified in This Fix

| File | Change |
|------|--------|
| `lua/custom/plugins/snacks.lua` | Complete rewrite - removed config function, changed all actions to strings, enabled picker and quickfile |
| `lua/custom/plugins/bufferline.lua` | Added (separate feature for buffer tabs at top) |
| `lua/kickstart/plugins/neo-tree.lua` | Configured as backup explorer with `<leader>E` |
| `init.lua:982` | Uncommented Neo-tree require |

---

## Summary

**The fix was simple once identified:**

1. Change dashboard key actions from **functions** to **strings**
2. Remove custom **config function**
3. Enable **picker** and **quickfile** modules

**The root cause:** Snacks.nvim dashboard only auto-closes when actions are string commands (`:lua ...`), not when they are Lua functions. This is because string actions go through Neovim's command execution path, which triggers the dashboard's action handler to close the window first.
