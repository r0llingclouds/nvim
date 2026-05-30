-- Jupyter / interactive notebook workflow for ML EDA.
--
-- PREREQUISITES (one-time, outside Neovim):
--   pip install pynvim jupyter_client jupytext   (into the env you select with <leader>vs)
--   brew install imagemagick                     (for inline plot rendering)
--   :UpdateRemotePlugins                          (after first install of molten)
--
-- Ghostty speaks the Kitty graphics protocol, so inline matplotlib/seaborn plots
-- render in-buffer. Inside tmux you also need `set -g allow-passthrough on`.

return {
  {
    'benlubas/molten-nvim',
    version = '^1.0.0',
    ft = { 'python', 'markdown', 'quarto' },
    -- NOTE: after `pip install pynvim`, run `:UpdateRemotePlugins` once manually
    -- (kept off the build step so it doesn't error before pynvim exists).
    dependencies = { '3rd/image.nvim' },
    init = function()
      vim.g.molten_image_provider = 'image.nvim'
      vim.g.molten_output_win_max_height = 20
      vim.g.molten_auto_open_output = false
      vim.g.molten_wrap_output = true
      vim.g.molten_virt_text_output = true
      vim.g.molten_virt_lines_off_by_1 = true
    end,
    keys = {
      { '<leader>ji', '<cmd>MoltenInit<cr>', desc = 'Molten: init kernel' },
      { '<leader>jl', '<cmd>MoltenEvaluateLine<cr>', desc = 'Molten: eval line' },
      { '<leader>je', '<cmd>MoltenEvaluateOperator<cr>', desc = 'Molten: eval operator' },
      { '<leader>jr', '<cmd>MoltenReevaluateCell<cr>', desc = 'Molten: re-eval cell' },
      { '<leader>jv', ':<C-u>MoltenEvaluateVisual<cr>gv', mode = 'v', desc = 'Molten: eval visual' },
      { '<leader>jo', '<cmd>MoltenShowOutput<cr>', desc = 'Molten: show output' },
      { '<leader>jd', '<cmd>MoltenDelete<cr>', desc = 'Molten: delete cell' },
    },
  },

  {
    '3rd/image.nvim',
    opts = {
      backend = 'kitty',
      processor = 'magick_cli', -- uses the ImageMagick CLI; no luarocks needed
      integrations = {
        markdown = { enabled = true, only_render_image_at_cursor = true },
      },
      max_width_window_percentage = 50,
    },
  },

  -- Edit .ipynb notebooks as percent-cell markdown.
  {
    'GCBallesteros/jupytext.nvim',
    lazy = false, -- must intercept .ipynb on open
    opts = { style = 'markdown', output_extension = 'auto', force_ft = nil },
  },
}
