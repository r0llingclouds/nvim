-- Tmux integration
-- Seamless navigation between Neovim and tmux panes

return {
  'christoomey/vim-tmux-navigator',
  lazy = false,
  keys = {
    { '<C-h>', '<cmd>TmuxNavigateLeft<cr>', desc = 'Go to left window' },
    { '<C-j>', '<cmd>TmuxNavigateDown<cr>', desc = 'Go to lower window' },
    { '<C-k>', '<cmd>TmuxNavigateUp<cr>', desc = 'Go to upper window' },
    { '<C-l>', '<cmd>TmuxNavigateRight<cr>', desc = 'Go to right window' },
  },
}
