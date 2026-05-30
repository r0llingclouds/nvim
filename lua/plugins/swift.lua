-- Swift / iOS: sourcekit-lsp (ships with Xcode, not Mason) + xcodebuild.nvim.
--
-- For real iOS work:
--   sudo xcode-select -s /Applications/Xcode.app/Contents/Developer   (CommandLineTools hides the iOS SDK)
--   sudo xcodebuild -license accept && xcodebuild -runFirstLaunch
--   brew install xcode-build-server swiftformat swiftlint
--   in an app project: `xcode-build-server config -scheme <Scheme> -project App.xcodeproj`
--   (generates buildServer.json so sourcekit indexes .xcworkspace/.xcodeproj apps)

vim.lsp.config.sourcekit = {
  cmd = { 'xcrun', 'sourcekit-lsp' },
  filetypes = { 'swift', 'objective-c', 'objective-cpp' },
  -- buildServer.json (from xcode-build-server) is what makes xcodeproj/xcworkspace apps index.
  root_markers = { 'buildServer.json', 'Package.swift', '.git' },
}

vim.lsp.enable 'sourcekit'

return {
  {
    'wojciech-kulik/xcodebuild.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
      'MunifTanjim/nui.nvim',
    },
    ft = { 'swift', 'objc', 'objcpp' },
    cmd = { 'XcodebuildPicker', 'XcodebuildBuild', 'XcodebuildBuildRun', 'XcodebuildTest' },
    config = function()
      require('xcodebuild').setup {}
    end,
    keys = {
      { '<leader>X', '<cmd>XcodebuildPicker<cr>', desc = '[X]code actions' },
      { '<leader>Xb', '<cmd>XcodebuildBuild<cr>', desc = 'Xcode build' },
      { '<leader>Xr', '<cmd>XcodebuildBuildRun<cr>', desc = 'Xcode build & run' },
      { '<leader>Xt', '<cmd>XcodebuildTest<cr>', desc = 'Xcode test' },
      { '<leader>Xd', '<cmd>XcodebuildSelectDevice<cr>', desc = 'Xcode select device' },
      { '<leader>Xl', '<cmd>XcodebuildToggleLogs<cr>', desc = 'Xcode toggle logs' },
    },
  },
}
