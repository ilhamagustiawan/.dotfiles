-- return {
--   settings = {
--     Lua = {
--       runtime = {
--         -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
--         version = "LuaJIT",
--         -- Setup your lua path
--         path = vim.split(package.path, ";"),
--       },
--       diagnostics = {
--         -- Get the language server to recognize the `vim` global
--         globals = { "vim", "PLUGINS" },
--       },
--       workspace = {
--         -- Make the server aware of Neovim runtime files
--         library = {
--           [vim.fn.expand "$VIMRUNTIME/lua"] = true,
--           [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
--           -- "${3rd}/luv/library",
--           -- unpack(vim.api.nvim_get_runtime_file("", true)),
--         },
--         maxPreload = 2000,
--         preloadFileSize = 50000,
--       },
--       completion = { callSnippet = "Replace" },
--       telemetry = { enable = false },
--       hint = { enable = true },
--     },
--   },
-- }

---@type vim.lsp.Config
return {
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace",
        displayContext = 5,
        keywordSnippet = "Replace",
      },
      diagnostics = { workspaceEvent = "OnSave", unusedLocalExclude = { "_*" } },
      format = {
        enable = false,
        defaultConfig = {
          indent_style = "space",
          indent_size = 2,
          quote_style = "double",
        },
      },
      hint = { enable = true, setType = true },
      hover = { expandAlias = false },
      language = { fixIndent = false },

      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },

      type = { inferParamType = true },
      typeFormat = { enable = false },
      workspace = {
        useGitIgnore = true,
        checkThirdParty = false,
        ignoreDir = { "test_build" },
      },
    },
  },
  on_attach = function(client, _)
    client.server_capabilities.documentOnTypeFormattingProvider = nil
    -- vim.schedule(function()
    --   local winnr = vim.fn.bufwinid(bufnr)
    --   vim.wo[winnr].foldlevel = 999
    -- end)
  end,
}
