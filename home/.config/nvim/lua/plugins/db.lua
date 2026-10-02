return {
  {
    "kristijanhusak/vim-dadbod-ui",
    enabled = false,
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true }, -- Optional
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
    end,
  },
  {
    "kndndrj/nvim-dbee",
    enabled = false,
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    build = function()
      require("dbee").install()
    end,
    config = function()
      require("dbee").setup {
        editor = {
          -- see drawer comment.
          window_options = {},
          buffer_options = {},

          -- directory where to store the scratchpads.
          --directory = "path/to/scratchpad/dir",

          -- mappings for the buffer
          mappings = {
            -- run what's currently selected on the active connection
            { key = "<leader>S", mode = "v", action = "run_selection" },
            -- run the whole file on the active connection
            { key = "<leader>S", mode = "n", action = "run_file" },
          },
        },
      }
    end,
  },
}
