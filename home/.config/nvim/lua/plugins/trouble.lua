return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  event = "VimEnter",
  keys = {
    {
      "<leader>ea",
      "<cmd>Trouble diagnostics toggle<cr>",
      desc = "Diagnostics (Trouble)",
    },
    {
      "<leader>ex",
      "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
      desc = "Buffer Diagnostics (Trouble)",
    },
  },
  opts = {
    auto_close = true, -- auto close when there are no items
    {
      modes = {
        diagnostics = {
          groups = {
            { "filename", format = "{file_icon} {basename:Title} {count}" },
          },
        },
      },
    },
  },
}
