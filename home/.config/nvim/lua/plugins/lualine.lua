return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("lualine").setup {
      options = {
        icons_enabled = true,
        theme = "gruvbox",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = true,
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {
          "branch",
          "diff",
          "diagnostics",
        },
        lualine_c = {
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          {
            "filename",
            file_status = true, -- displays file status (readonly status, modified status)
            path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
            symbols = {
              modified = " ●", -- Text to show when the buffer is modified
              alternate_file = "#", -- Text to show to identify the alternate file
              directory = "", -- Text to show when the buffer is a directory
            },
            padding = { left = 0, right = 1 },
          },
        },
        lualine_x = {
          "overseer",
          {
            function()
              return " "
            end,
          },
          "encoding",
          "fileformat",
        },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      -- inactive_sections = {
      --   lualine_a = {},
      --   lualine_b = {},
      --   lualine_c = { "filename" },
      --   lualine_x = { "location" },
      --   lualine_y = {},
      --   lualine_z = {},
      -- },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {
        "quickfix",
        "aerial",
        "nvim-tree",
        "nvim-dap-ui",
        "neo-tree",
        "lazy",
        "fugitive",
        "man",
        "trouble",
      },
    }
  end,
}
