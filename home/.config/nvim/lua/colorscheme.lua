if vim.g.vscode then return end

vim.o.background = "dark"

local themes = {
  win32 = "kanagawa-dragon",
  mac = "kanagawa-dragon",
  unix = "gruvbox-material",
  light = "rose-pine-dawn",
}

local os = vim.fn.has("win32") == 1 and "win32" or (vim.fn.has("mac") == 1 and "mac" or "unix")
local theme = vim.o.background == "light" and themes.light or themes[os]

pcall(vim.cmd.colorscheme, theme or "default")
