local M = {}

local diagnostic_icons = require("icons").diagnostics

local virtual_lines_opts = {
  format = function(diagnostic)
    -- Use shorter, nicer names for some sources:
    local special_sources = {
      ["Lua Diagnostics."] = "lua",
      ["Lua Syntax Check."] = "lua",
    }

    local level = vim.diagnostic.severity[diagnostic.severity]
    local message = diagnostic_icons[level] or ""
    if diagnostic.source then
      message = string.format("%s %s", message, special_sources[diagnostic.source] or diagnostic.source)
    end
    if diagnostic.code then
      message = string.format("%s[%s]", message, diagnostic.code)
    end

    return message .. " "
  end,
}

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

M.virtual_lines_opts = virtual_lines_opts
M.diagnostic_icons = diagnostic_icons

return M
