return {
  "abreujp/scholar.nvim",
  priority = 1000,
  config = function()
    require("scholar").setup({
      -- your configuration here
    })

    -- For light theme (primary)
    -- vim.o.background = "light"
    -- vim.cmd("colorscheme scholar")

    -- OR for dark theme
    -- vim.o.background = "dark"
    -- vim.cmd("colorscheme scholar")
  end,
}
