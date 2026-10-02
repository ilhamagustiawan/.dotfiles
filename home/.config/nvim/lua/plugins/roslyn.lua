return {
  {
    "seblyng/roslyn.nvim",
    enabled = vim.fn.has "win32" == 1,
    -- enabled = false,
    ft = "cs",
    ---@module 'roslyn.config'
    ---@type RoslynNvimConfig
    opts = {},
  },
  {
    "GustavEikaas/easy-dotnet.nvim",
    ft = "cs",
    -- enabled = vim.fn.has("win32") == 1,
    enabled = false,
    dependencies = { "nvim-lua/plenary.nvim", "folke/snacks.nvim" },
    config = function()
      local dotnet = require("easy-dotnet")
      dotnet.setup({
        debugger = {
          -- The path to netcoredbg executable
          bin_path = vim.fn.expand("$MASON/packages/netcoredbg/netcoredbg"),
          auto_register_dap = true,
          mappings = {
            open_variable_viewer = { lhs = "T", desc = "open variable viewer" },
          },
        },
      })
    end,
  },
}
