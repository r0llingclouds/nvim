-- Filetype overrides
-- See `:help vim.filetype.add`

vim.filetype.add {
  extension = {
    -- Unity asset sidecars are YAML
    meta = 'yaml',
    -- Shader includes / compute / HLSL → treat as HLSL (Neovim ships an hlsl ftplugin).
    -- NOTE: bare `.shader` (ShaderLab) is its own DSL — left unmapped on purpose
    -- (mapping it to glsl/hlsl mis-highlights the Properties/SubShader/Pass wrapper).
    cginc = 'hlsl',
    hlsl = 'hlsl',
    compute = 'hlsl',
    shadergraph = 'json',
  },
}
