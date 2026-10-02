local M = {}

--- Setup hover/signature and dynamic capability handling.
---@param on_attach function  Called with (client, bufnr) when LSP attaches
---@param virtual_lines_opts table Options used when showing virtual line diagnostics
---@param methods table lsp protocol methods table
function M.setup(on_attach, virtual_lines_opts, methods)
  -- Override hover with rounded border and size limits
  local hover = vim.lsp.buf.hover
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.lsp.buf.hover = function()
    return hover {
      border = "rounded",
      max_height = math.floor(vim.o.lines * 0.5),
      max_width = math.floor(vim.o.columns * 0.4),
    }
  end

  -- Override signature help with rounded border and size limits
  local signature_help = vim.lsp.buf.signature_help
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.lsp.buf.signature_help = function()
    return signature_help {
      border = "rounded",
      max_height = math.floor(vim.o.lines * 0.5),
      max_width = math.floor(vim.o.columns * 0.4),
    }
  end

  -- Update mappings when registering dynamic capabilities.
  local register_capability = vim.lsp.handlers[methods.client_registerCapability]
  vim.lsp.handlers[methods.client_registerCapability] = function(err, res, ctx)
    local client = vim.lsp.get_client_by_id(ctx.client_id)
    if not client then
      return
    end

    on_attach(client, vim.api.nvim_get_current_buf())

    return register_capability(err, res, ctx)
  end

  -- Ensure keymaps are set when an LSP attaches.
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("agustiawan/lsp", { clear = true }),
    desc = "Configure LSP keymaps",
    callback = function(args)
      local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

      if not client then
        return
      end

      on_attach(client, args.buf)
    end,
  })
end

return M
