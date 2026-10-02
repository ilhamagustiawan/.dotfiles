vim.api.nvim_create_user_command("ToggleInlayHints", function()
  vim.g.inlay_hints = not vim.g.inlay_hints
  vim.notify(string.format("%s inlay hints...", vim.g.inlay_hints and "Enabling" or "Disabling"), vim.log.levels.INFO)
  local mode = vim.api.nvim_get_mode().mode
  vim.lsp.inlay_hint.enable(vim.g.inlay_hints and (mode == "n" or mode == "v"))
end, { desc = "Toggle inlay hints", nargs = 0 })

vim.api.nvim_create_user_command("Scratch", function()
  vim.cmd "bel 10new"
  local buf = vim.api.nvim_get_current_buf()
  for name, value in pairs {
    filetype = "scratch",
    buftype = "nofile",
    bufhidden = "wipe",
    swapfile = false,
    modifiable = true,
  } do
    vim.api.nvim_set_option_value(name, value, { buf = buf })
  end
end, { desc = "Open a scratch buffer", nargs = 0 })

vim.api.nvim_create_user_command("ToggleVirtualLines", function()
  local new_config = not vim.diagnostic.config().virtual_lines
  vim.diagnostic.config { virtual_lines = new_config }
end, { desc = "Toggle diagnostic virtual_lines", nargs = 0 })

vim.api.nvim_create_user_command("W", function()
  vim.cmd "write"
end, { desc = "Write the current file", nargs = 0 })

vim.api.nvim_create_user_command("FormatJSON", function()
  vim.cmd "%!jq ."
end, { desc = "Format JSON with jq", nargs = 0 })
