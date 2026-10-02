vim.filetype.add {
  filename = {
    [".eslintrc.json"] = "jsonc",
  },
  extension = {
    edge = "html",
    codecompanion = "markdown",
    ["http"] = "http",
  },
  pattern = {
    ["tsconfig*.json"] = "jsonc",
    [".*/%.vscode/.*%.json"] = "jsonc",
  },
}
