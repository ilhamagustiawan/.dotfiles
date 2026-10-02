if vim.loader ~= nil and type(vim.loader.enable) == "function" then
  vim.loader.enable()
end

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  }
end

vim.opt.rtp:prepend(lazypath)

if vim.g.vscode then
  require "nvim-vscode"
else
  require "options"
  require "keymaps"
  require "autocmd"
  require "command"

  require("lazy").setup("plugins", {
    ui = {
      border = "rounded",
    },
    change_detection = { notify = false },
    performance = {
      rtp = {
        -- Stuff I don't use.
        disabled_plugins = {
          "2html_plugin",
          "fzf",
          "getscript",
          "getscriptPlugin",
          "gzip",
          "logipat",
          "netrw",
          "netrwPlugin",
          "netrwSettings",
          "netrwFileHandlers",
          "matchparen",
          "tar",
          "tarPlugin",
          "rrhelper",
          "vimball",
          "vimballPlugin",
          "zip",
          "zipPlugin",
        },
      },
    },
  })

  pcall(require, "colorscheme")
  pcall(require, "lsp") 
end
