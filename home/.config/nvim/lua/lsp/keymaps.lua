local M = {}
local methods = vim.lsp.protocol.Methods
local diagnostics = require("lsp.diagnostics")
local diagnostic_icons = diagnostics.diagnostic_icons
local virtual_lines_opts = diagnostics.virtual_lines_opts

--- Sets up LSP keymaps and autocommands for the given buffer.
---@param client vim.lsp.Client
---@param bufnr integer
function M.on_attach(client, bufnr)
  local map = function(keys, func, desc, mode)
    mode = mode or "n"
    vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
  end

  map("gk", vim.lsp.buf.hover, "Hover documentation")

  map("<leader>ee", vim.diagnostic.open_float, "Show diagnostics")

  vim.keymap.set("n", "[e", function()
    vim.diagnostic.jump { count = -1, float = true }
  end, { desc = "Previous diagnostic" })

  vim.keymap.set("n", "]e", function()
    vim.diagnostic.jump { count = 1, float = true }
  end, { desc = "Next diagnostic" })

  vim.keymap.set("n", "<leader>es", function()
    vim.diagnostic.config { virtual_lines = { current_line = true } }
    vim.api.nvim_create_autocmd("CursorMoved", {
      group = vim.api.nvim_create_augroup("agustiawan-line-diagnostics", { clear = true }),
      callback = function()
        vim.diagnostic.config { virtual_lines = false, virtual_text = true, format = virtual_lines_opts }
        return true
      end,
    })
  end)

  if client:supports_method(methods.textDocument_documentHighlight) then
    local under_cursor_highlights_group = vim.api.nvim_create_augroup("agustiawan/cursor_highlights", { clear = false })
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      group = under_cursor_highlights_group,
      desc = "Highlight references under the cursor",
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      group = under_cursor_highlights_group,
      desc = "Clear highlight references",
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })

    vim.api.nvim_create_autocmd("LspDetach", {
      group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
      callback = function(event2)
        vim.lsp.buf.clear_references()
        vim.api.nvim_clear_autocmds { group = "agustiawan/cursor_highlights", buffer = event2.buf }
      end,
    })
  end
end

return M
