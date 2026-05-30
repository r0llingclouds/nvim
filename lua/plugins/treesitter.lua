-- Treesitter: Highlight, edit, and navigate code (main-branch API)

return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = ':TSUpdate',
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'main' },
    },
    config = function()
      -- main-branch API: install parsers explicitly. Now covers the languages
      -- actually used here (python, c#, ts/tsx/js, swift, json/yaml/toml, css …)
      -- instead of just the kickstart defaults.
      require('nvim-treesitter').install {
        'bash', 'c', 'c_sharp', 'comment', 'css', 'diff', 'html', 'javascript',
        'jsdoc', 'json', 'lua', 'luadoc', 'markdown', 'markdown_inline',
        'objc', 'python', 'query', 'regex', 'swift', 'toml', 'tsx', 'typescript',
        'vim', 'vimdoc', 'yaml',
      }

      -- Filetypes where treesitter indent is solid. Python is intentionally
      -- excluded — its indent query mis-handles comprehensions/returns, and
      -- ruff_format on save already gives good Python indentation.
      local ts_indent_ft = {
        typescript = true,
        typescriptreact = true,
        javascript = true,
        javascriptreact = true,
        cs = true,
      }

      -- Start highlighting per-buffer; auto-install a missing-but-available
      -- parser on first open so new filetypes light up without manual steps.
      local function ensure_and_start(buf)
        local ft = vim.bo[buf].filetype
        local lang = vim.treesitter.language.get_lang(ft)
        if not lang then
          return
        end
        local nts = require 'nvim-treesitter'

        local function start()
          if not vim.api.nvim_buf_is_valid(buf) then
            return
          end
          pcall(vim.treesitter.start, buf)
          if ts_indent_ft[ft] then
            vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end

        if vim.tbl_contains(nts.get_installed 'parsers', lang) then
          start()
        elseif vim.tbl_contains(require('nvim-treesitter.config').get_available(), lang) then
          local job = nts.install { lang }
          if job and job.await then
            job:await(function()
              vim.schedule(start)
            end)
          end
        end
      end

      vim.api.nvim_create_autocmd('FileType', {
        callback = function(args)
          pcall(ensure_and_start, args.buf)
        end,
      })

      -- Additional vim regex highlighting for Ruby
      vim.api.nvim_create_autocmd('FileType', {
        pattern = 'ruby',
        callback = function()
          vim.opt_local.syntax = 'on'
        end,
      })

      -- Treesitter text objects: function/class/parameter select + move + swap.
      pcall(function()
        require('nvim-treesitter-textobjects').setup {
          select = {
            lookahead = true,
            selection_modes = { ['@function.outer'] = 'V', ['@class.outer'] = 'V' },
          },
          move = { set_jumps = true },
        }

        local sel = require 'nvim-treesitter-textobjects.select'
        for _, m in ipairs {
          { 'af', '@function.outer' },
          { 'if', '@function.inner' },
          { 'ac', '@class.outer' },
          { 'ic', '@class.inner' },
          { 'aa', '@parameter.outer' },
          { 'ia', '@parameter.inner' },
        } do
          vim.keymap.set({ 'x', 'o' }, m[1], function()
            sel.select_textobject(m[2], 'textobjects')
          end, { desc = 'TS ' .. m[2] })
        end

        local mv = require 'nvim-treesitter-textobjects.move'
        vim.keymap.set({ 'n', 'x', 'o' }, ']f', function()
          mv.goto_next_start('@function.outer', 'textobjects')
        end, { desc = 'Next function start' })
        vim.keymap.set({ 'n', 'x', 'o' }, '[f', function()
          mv.goto_previous_start('@function.outer', 'textobjects')
        end, { desc = 'Prev function start' })

        local sw = require 'nvim-treesitter-textobjects.swap'
        vim.keymap.set('n', '<leader>cp', function()
          sw.swap_next '@parameter.inner'
        end, { desc = '[C]ode swap [p]arameter next' })
      end)
    end,
  },

  -- Sticky scroll: keep the enclosing def/class header on screen.
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = { max_lines = 3, multiline_threshold = 1, trim_scope = 'outer', mode = 'cursor' },
  },
}
