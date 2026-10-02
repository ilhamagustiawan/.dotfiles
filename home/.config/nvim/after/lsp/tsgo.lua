-- `tsgo` is used solely for diagnostics. All interactive capabilities are
-- delegated to `vtsls`, which is silenced for diagnostics in lua/lsp/init.lua.
-- If `tsgo` fails to attach, no TS diagnostics will be published by design
-- (no fallback to vtsls diagnostics).
---@type vim.lsp.Config
return {
  on_attach = function(client)
    local caps = client.server_capabilities

    -- Navigation / symbol resolution -> vtsls
    caps.definitionProvider = false
    caps.declarationProvider = false
    caps.typeDefinitionProvider = false
    caps.implementationProvider = false
    caps.referencesProvider = false
    caps.documentHighlightProvider = false
    caps.callHierarchyProvider = false

    -- Editor interaction -> vtsls
    caps.hoverProvider = false
    caps.signatureHelpProvider = false
    caps.renameProvider = false
    caps.codeActionProvider = false

    -- Completion / intellisense -> vtsls
    caps.completionProvider = nil

    -- Symbols -> vtsls
    caps.documentSymbolProvider = false
    caps.workspaceSymbolProvider = false

    -- Tokens / hints -> vtsls
    caps.semanticTokensProvider = nil
    caps.inlayHintProvider = false

    -- Formatting -> conform / vtsls
    caps.documentFormattingProvider = false
    caps.documentRangeFormattingProvider = false
  end,
}
