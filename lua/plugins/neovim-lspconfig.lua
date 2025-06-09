return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        sourcekit = {
          cmd = { "/usr/bin/sourcekit-lsp" }, -- Update this path
        },
      },
    },
  },
}
