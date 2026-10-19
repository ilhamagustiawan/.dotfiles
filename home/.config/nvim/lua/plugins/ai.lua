return {
  {
    "nickjvandyke/opencode.nvim",
    branch = "main", -- OpenCode V2
    event = "VeryLazy",
    dependencies = {
      "folke/snacks.nvim",
      "j-hui/fidget.nvim",
    },
    keys = {
      {
        "<leader>aa",
        function()
          require("custom.ai").toggle()
        end,
        desc = "Toggle AI chat",
      },
      {
        "<leader>ae",
        function()
          require("opencode").ask "Help me edit this code. @buffer @this "
        end,
        mode = { "n", "x" },
        desc = "Edit code with OpenCode",
      },
      {
        "<leader>am",
        function()
          require("opencode").ask "Suggest a Neovim Ex command for the following task. Explain it without executing it: "
        end,
        desc = "Generate command with OpenCode",
      },
      {
        "<leader>ac",
        function()
          local visual = vim.fn.mode():match "[vV\22]"
          require("opencode").ask(visual and "@this " or "@buffer ")
        end,
        mode = { "n", "x" },
        desc = "Add context to AI prompt",
      },
      {
        "<leader>ap",
        function()
          require("opencode").select()
        end,
        mode = { "n", "x" },
        desc = "AI actions",
      },
      {
        "<leader>aug",
        function()
          require("custom.ai").generate_commit()
        end,
        desc = "Generate commit message with OpenCode",
        ft = "gitcommit",
      },
    },
    init = function()
      ---@type opencode.Opts
      vim.g.opencode_opts = {
        server = {
          start = function()
            require("custom.ai").open()
          end,
        },
      }
    end,
    config = function()
      require("custom.ai").setup()
    end,
  },
}
