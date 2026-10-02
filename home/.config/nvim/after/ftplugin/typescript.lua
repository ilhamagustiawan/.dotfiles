-- TypeScript filetype settings with best practices

-- Set indentation to 2 spaces
vim.opt_local.tabstop = 2
vim.opt_local.shiftwidth = 2
vim.opt_local.softtabstop = 2
vim.opt_local.expandtab = true

-- Enable autoindenting
vim.opt_local.autoindent = true
vim.opt_local.smartindent = true
vim.opt_local.cindent = true

-- Text width settings for readability
vim.opt_local.textwidth = 120
vim.opt_local.colorcolumn = '120'

-- Don't wrap lines by default in code
vim.opt_local.wrap = false