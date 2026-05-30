-- C# / Unity language server: Microsoft Roslyn LS (replaces OmniSharp).
-- Far faster on Unity's large generated .sln/.csproj.
--
-- Install: the Crashdummyy mason registry is added in lsp.lua; run `:MasonInstall roslyn`.
-- Also remove the legacy server once: `:MasonUninstall omnisharp`.

return {
  'seblyng/roslyn.nvim',
  ft = 'cs',
  opts = {
    broad_search = true, -- find the Unity-generated .sln at project root
    filewatching = 'off', -- CRITICAL for Unity: 'auto' causes 2-3s save freezes
    lock_target = true, -- stay attached to the chosen .sln across buffers
  },
}
