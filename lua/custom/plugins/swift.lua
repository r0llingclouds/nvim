-- Swift LSP support via sourcekit-lsp (comes with Xcode, not Mason)
vim.lsp.config.sourcekit = {
  cmd = { 'xcrun', 'sourcekit-lsp' },
  filetypes = { 'swift', 'objective-c', 'objective-cpp' },
  root_markers = { 'Package.swift', '.git' },
}

vim.lsp.enable('sourcekit')

return {}
