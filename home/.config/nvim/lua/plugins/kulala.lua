return {
  "mistweaverco/kulala.nvim",
  ft = { "http", "rest" },
  opts = {
    global_keymaps = false,
    global_keymaps_prefix = "<leader>R",
    kulala_keymaps_prefix = "",
  },
  config = function(_, opts)
    require("kulala").setup(opts)
    vim.api.nvim_create_autocmd("FileType", {
      pattern = { "http", "rest" },
      callback = function(ev)
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, desc = desc })
        end

        map({ "n", "v" }, "<CR>", function()
          require("kulala").run()
        end, "Send request")
        map("n", "<leader>rb", function()
          require("kulala").scratchpad()
        end, "Open scratchpad")
        map("n", "<leader>rp", function()
          require("kulala").from_curl()
        end, "Paste from curl")
        map("n", "<leader>rf", function()
          require("kulala").search()
        end, "Search")
      end,
    })
  end,
}
