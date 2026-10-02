return {
  {
    "zbirenbaum/copilot.lua",
    enabled = false,
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup {
        server = {
          type = "binary",
        },
        panel = {
          enabled = true,
          auto_refresh = true,
          keymap = {
            jump_prev = "[[",
            jump_next = "]]",
            accept = "<CR>",
            refresh = "r",
            open = false,
          },
          layout = {
            position = "bottom",
            ratio = 0.4,
          },
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          hide_during_completion = true,
          trigger_on_accept = true,
          keymap = {
            accept = false,
            accept_word = "<Right>",
            accept_line = "<Down>",
            next = "<s-right>",
            prev = "<s-left>",
            dismiss = "<C-]>",
          },
        },
        nes = {
          enabled = false,
          auto_trigger = true,
          keymap = {
            accept_and_goto = false,
            accept = false,
            dismiss = false,
          },
        },
        telemetry = {
          telemetryLevel = "off",
        },
      }
      vim.keymap.set("i", "<Tab>", function()
        if require("copilot.suggestion").is_visible() then
          require("copilot.suggestion").accept()
        end
      end)
    end,
  },
  {
    "sudo-tee/opencode.nvim",
    enabled = true,
    event = "VeryLazy",
    dependencies = {
      "MeanderingProgrammer/render-markdown.nvim",
      "saghen/blink.cmp",
      "folke/snacks.nvim",
    },
    opts = {
      ui = {
        input = {
          text = {
            wrap = true,
          },
        },
      },
      keymap_prefix = "<leader>a",
      keymap = {
        editor = {
          ["<leader>aa"] = { "toggle" },
          ["<leader>ae"] = { "quick_chat", mode = { "n", "x" } },
          ["<leader>aug"] = {
            function()
              require("opencode.api").quick_chat "Write a conventional commit message #diff"
            end,
            desc = "Generate commit message",
          },
        },
        input_window = {
          ["<c-c>"] = { "close" },
          ["<esc>"] = { "cancel" },
          ["<tab>"] = { "switch_mode", mode = { "n" } },
          ["<c-t>"] = { "cycle_variant", mode = { "n", "i" } },
          ["<cr>"] = { "submit_input_prompt", { "n" } },
        },
        output_window = {
          ["<c-c>"] = { "close" },
          ["<esc>"] = { "cancel" },
          ["<tab>"] = false,
        },
      },
      quick_chat = {
        default_model = "github-copilot/gpt-5-mini",
      },
    },
  },
}
