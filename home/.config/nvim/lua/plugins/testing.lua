return {
  {
    "nvim-neotest/neotest",
    enabled = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "rouge8/neotest-rust",
      "nvim-neotest/neotest-plenary",
      "nvim-neotest/neotest-go",
      "stevearc/overseer.nvim",
      "nsidorenco/neotest-vstest",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local ok, neotest = pcall(require, "neotest")
      if not ok then
        return
      end

      -- get neotest namespace (api call creates or returns namespace)
      local neotest_ns = vim.api.nvim_create_namespace "neotest"
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)

      neotest.setup {
        consumers = {
          overseer = require "neotest.consumers.overseer",
        },
        overseer = {
          enabled = true,
          -- When this is true (the default), it will replace all neotest.run.* commands
          force_default = false,
        },
        status = {
          virtual_text = true,
          signs = false,
        },
        summary = {
          mappings = {
            stop = "x",
          },
        },
        icons = {
          running_animated = {
            "⠋",
            "⠙",
            "⠚",
            "⠒",
            "⠂",
            "⠂",
            "⠒",
            "⠲",
            "⠴",
            "⠦",
            "⠖",
            "⠒",
            "⠐",
            "⠐",
            "⠒",
            "⠓",
            "⠋",
          },
        },
        strategies = {
          integrated = {
            width = 180,
          },
        },
        adapters = {
          require "neotest-plenary",
          require "neotest-rust",
          require "neotest-vstest",
          require "neotest-go" {
            recursive_run = true,
            experimental = {
              test_table = true,
            },
            -- args = { "-count=1", "-timeout=60s" },
          },
        },
      }

      local keymap = vim.keymap.set

      keymap("n", "<leader>tt", neotest.run.run)
      keymap("n", "<leader>tw", function()
        neotest.run.run(vim.fn.getcwd())
      end)
      keymap("n", "<leader>tf", function()
        neotest.run.run(vim.fn.expand "%")
      end)
      keymap("n", "<leader>td", function()
        if vim.bo.filetype == "go" then
          require("dap-go").debug_test()
        else
          neotest.run.run { strategy = "dap" }
        end
      end)
      keymap("n", "<leader>tx", neotest.run.stop)
      keymap("n", "<leader>tl", neotest.run.run_last)
      keymap("n", "<leader>tc", neotest.run.attach)
      keymap("n", "<leader>ts", neotest.summary.open)
      keymap("n", "<leader>to", neotest.output.open)
      keymap("n", "<leader>te", neotest.output_panel.toggle)
      keymap("n", "<leader>tS", function()
        require("neotest").watch.toggle(vim.fn.expand "%")
      end)
    end,
  },
}
