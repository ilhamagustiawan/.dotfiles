if vim.g.vscode then
  return
end

local methods = vim.lsp.protocol.Methods
local diagnostics = require "lsp.diagnostics"
local diagnostic_icons = diagnostics.diagnostic_icons
local virtual_lines_opts = diagnostics.virtual_lines_opts
local lsp_keymaps = require "lsp.keymaps"
local on_attach = lsp_keymaps.on_attach

-- Define the diagnostic signs.
for severity, icon in pairs(diagnostic_icons) do
  local hl = "DiagnosticSign" .. severity:sub(1, 1) .. severity:sub(2):lower()
  vim.fn.sign_define(hl, { text = icon, texthl = hl })
end

-- Diagnostic configuration.
vim.diagnostic.config {
  virtual_text = {
    prefix = "",
    severity = {
      min = vim.diagnostic.severity.ERROR,
    },
    spacing = 2,
  },
  float = {
    source = "if_many",
    -- Show severity icons as prefixes.
    prefix = function(diag)
      local level = vim.diagnostic.severity[diag.severity]
      local prefix = string.format(" %s ", diagnostic_icons[level])
      return prefix, "Diagnostic" .. level:gsub("^%l", string.upper)
    end,
  },
  -- Disable signs in the gutter.
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = diagnostic_icons.ERROR,
      [vim.diagnostic.severity.WARN] = diagnostic_icons.WARN,
      [vim.diagnostic.severity.INFO] = diagnostic_icons.INFO,
      [vim.diagnostic.severity.HINT] = diagnostic_icons.HINT,
    },
  },
}

-- Override the virtual text diagnostic handler so that the most severe diagnostic is shown first.
local show_handler = vim.diagnostic.handlers.virtual_text.show
assert(show_handler)
local hide_handler = vim.diagnostic.handlers.virtual_text.hide
vim.diagnostic.handlers.virtual_text = {
  show = function(ns, bufnr, diagnostics, opts)
    table.sort(diagnostics, function(diag1, diag2)
      return diag1.severity > diag2.severity
    end)
    return show_handler(ns, bufnr, diagnostics, opts)
  end,
  hide = hide_handler,
}

require("lsp.handlers").setup(on_attach, virtual_lines_opts, methods)

-- Enable LSP servers
local disabled_lsps = {
  "angularls",
  "ts_ls",
}
local lsp_configs = {}
for _, v in ipairs(vim.api.nvim_get_runtime_file("lsp/*", true)) do
  local name = vim.fn.fnamemodify(v, ":t:r")
  if not vim.tbl_contains(disabled_lsps, name) then
    table.insert(lsp_configs, name)
  end
end

local default_handler = vim.lsp.handlers["textDocument/publishDiagnostics"]
vim.lsp.handlers["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
  local client = vim.lsp.get_client_by_id(ctx.client_id)
  if client and client.name == "vtsls" then
    return -- silence vtsls diagnostics
  end
  return default_handler(err, result, ctx, config)
end

vim.lsp.enabled = lsp_configs
