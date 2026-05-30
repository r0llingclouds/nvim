---@diagnostic disable: undefined-global
-- LSP Configuration
-- nvim 0.11+ native vim.lsp.config / vim.lsp.enable, with Mason for install management.
-- Per-server settings live in vim.lsp.config(name, {...}); mason-lspconfig installs +
-- auto-enables them. (The old mason-lspconfig v2 `handlers` block was dead code — its
-- per-server settings never applied. This converges on the same pattern swift.lua uses.)

return {
  'neovim/nvim-lspconfig',
  dependencies = {
    -- Mason must be loaded before its dependents.
    {
      'mason-org/mason.nvim',
      opts = {
        registries = {
          'github:mason-org/mason-registry',
          'github:Crashdummyy/mason-registry', -- provides `roslyn` (C#/Unity LS)
        },
      },
    },
    'mason-org/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',

    -- Useful status updates for LSP
    { 'j-hui/fidget.nvim', opts = {} },

    -- blink.cmp already injects its enhanced capabilities globally via vim.lsp.config('*').
    'saghen/blink.cmp',

    -- JSON/YAML schema catalog for jsonls/yamlls
    'b0o/SchemaStore.nvim',
  },
  config = function()
    -- This runs when an LSP attaches to a particular buffer.
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
      callback = function(event)
        local client = vim.lsp.get_client_by_id(event.data.client_id)

        local map = function(keys, func, desc, mode)
          mode = mode or 'n'
          vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
        end

        -- Snacks picker LSP shortcuts
        map('gd', function() Snacks.picker.lsp_definitions() end, 'Goto Definition')
        map('gr', function() Snacks.picker.lsp_references() end, 'References')

        -- Rename the variable under your cursor
        map('grn', vim.lsp.buf.rename, '[R]e[n]ame')

        -- Execute a code action
        map('gra', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

        -- Find references for the word under your cursor
        map('grr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

        -- Jump to the implementation of the word under your cursor
        map('gri', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

        -- Jump to the definition of the word under your cursor
        map('grd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

        -- Goto Declaration
        map('grD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

        -- Fuzzy find all the symbols in your current document
        map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')

        -- Fuzzy find all the symbols in your current workspace
        map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')

        -- Jump to the type of the word under your cursor
        map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

        ---@param method vim.lsp.protocol.Method
        local function supports(method)
          return client and client:supports_method(method, event.buf)
        end

        -- Ruff is lint/fix/imports only; let basedpyright own hover for Python.
        if client and client.name == 'ruff' then
          client.server_capabilities.hoverProvider = false
        end

        -- Document highlighting under the cursor
        if client and supports(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
          local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
          vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd('LspDetach', {
            group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
            end,
          })
        end

        -- Inlay hints: on by default where supported, with a toggle.
        if client and supports(vim.lsp.protocol.Methods.textDocument_inlayHint) then
          vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
          map('<leader>th', function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }, { bufnr = event.buf })
          end, '[T]oggle Inlay [H]ints')
        end
      end,
    })

    -- Diagnostic Config
    vim.diagnostic.config {
      severity_sort = true,
      float = { border = 'rounded', source = 'if_many' },
      underline = { severity = vim.diagnostic.severity.ERROR },
      signs = vim.g.have_nerd_font and {
        text = {
          [vim.diagnostic.severity.ERROR] = '󰅚 ',
          [vim.diagnostic.severity.WARN] = '󰀪 ',
          [vim.diagnostic.severity.INFO] = '󰋽 ',
          [vim.diagnostic.severity.HINT] = '󰌶 ',
        },
      } or {},
      virtual_text = {
        source = 'if_many',
        spacing = 2,
        format = function(diagnostic)
          local diagnostic_message = {
            [vim.diagnostic.severity.ERROR] = diagnostic.message,
            [vim.diagnostic.severity.WARN] = diagnostic.message,
            [vim.diagnostic.severity.INFO] = diagnostic.message,
            [vim.diagnostic.severity.HINT] = diagnostic.message,
          }
          return diagnostic_message[diagnostic.severity]
        end,
      },
    }

    -- ── Per-server settings (native API) ───────────────────────────────────────
    -- blink.cmp injects capabilities globally; no manual merge needed here.

    vim.lsp.config('lua_ls', {
      settings = {
        Lua = {
          completion = { callSnippet = 'Replace' },
        },
      },
    })

    -- Python (types/hover). Ruff (below) owns lint/fix/imports.
    vim.lsp.config('basedpyright', {
      settings = {
        basedpyright = {
          analysis = {
            typeCheckingMode = 'standard', -- 'recommended' floods dynamic ML code
            diagnosticMode = 'openFilesOnly', -- lighter on large ML repos
            autoImportCompletions = true,
            inlayHints = {
              variableTypes = true,
              callArgumentNames = true,
              functionReturnTypes = true,
              genericTypes = false,
            },
          },
        },
      },
    })

    vim.lsp.config('ruff', {}) -- hover disabled on attach above

    -- TypeScript/JS — vtsls is the better-supported 2026 default (real inlay-hint settings).
    vim.lsp.config('vtsls', {
      settings = {
        typescript = {
          inlayHints = {
            parameterNames = { enabled = 'literals' },
            variableTypes = { enabled = false },
            propertyDeclarationTypes = { enabled = true },
            functionLikeReturnTypes = { enabled = true },
          },
          preferences = { importModuleSpecifier = 'non-relative' },
        },
        javascript = {
          inlayHints = { parameterNames = { enabled = 'all' } },
        },
      },
    })

    vim.lsp.config('tailwindcss', {
      filetypes = { 'html', 'css', 'scss', 'javascriptreact', 'typescriptreact', 'svelte', 'astro' },
    })

    vim.lsp.config('cssls', {})
    vim.lsp.config('html', {})
    vim.lsp.config('emmet_language_server', {
      filetypes = { 'html', 'css', 'javascriptreact', 'typescriptreact', 'svelte', 'astro' },
    })

    vim.lsp.config('jsonls', {
      settings = {
        json = {
          schemas = require('schemastore').json.schemas(),
          validate = { enable = true },
        },
      },
    })

    vim.lsp.config('yamlls', {
      settings = {
        yaml = {
          schemaStore = { enable = false, url = '' },
          schemas = require('schemastore').yaml.schemas(),
        },
      },
    })

    -- ── Tooling install (non-LSP CLIs: formatters + linters) ───────────────────
    require('mason-tool-installer').setup {
      ensure_installed = {
        'stylua', -- Lua formatter
        'csharpier', -- C# formatter
        'prettierd', -- JS/TS/JSON/CSS/etc formatter
        'ruff', -- Python linter/formatter (also runs as ruff LSP)
        'eslint_d', -- JS/TS linter
        'markdownlint', -- Markdown linter
        'taplo', -- TOML formatter
      },
    }

    -- ── Server install + auto-enable ───────────────────────────────────────────
    -- C# is handled by roslyn.nvim (see roslyn.lua), Swift by swift.lua — both
    -- excluded from automatic_enable so legacy/duplicate servers don't also attach.
    require('mason-lspconfig').setup {
      ensure_installed = {
        'lua_ls',
        'basedpyright',
        'ruff',
        'vtsls',
        'tailwindcss',
        'cssls',
        'html',
        'emmet_language_server',
        'jsonls',
        'yamlls',
      },
      -- Don't auto-enable leftover/legacy servers that may still be installed in Mason.
      automatic_enable = { exclude = { 'omnisharp', 'ts_ls' } },
    }
  end,
}
