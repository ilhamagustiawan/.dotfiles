return {
  {
    "olimorris/codecompanion.nvim",
    event = "VeryLazy",
    cmd = { "CodeCompanionChat", "CodeCompanionActions" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "MeanderingProgrammer/render-markdown.nvim",
      "saghen/blink.cmp",
      "folke/snacks.nvim",
      "j-hui/fidget.nvim",
    },
    keys = {
      { "<leader>aa", "<cmd>CodeCompanionChat Toggle<cr>", desc = "Toggle AI chat" },
      {
        "<leader>ae",
        function()
          require("codecompanion").chat {
            user_prompt = "Help me edit this code. #{buffer} #{selection}",
            auto_submit = false,
          }
        end,
        mode = { "n", "x" },
        desc = "Edit code with Codex chat",
      },
      {
        "<leader>am",
        function()
          require("codecompanion").chat {
            user_prompt = "Suggest a Neovim Ex command for the following task. Explain it without executing it: ",
            auto_submit = false,
          }
        end,
        desc = "Generate command with Codex chat",
      },
      { "<leader>ac", ":CodeCompanionChat Add<cr>", mode = { "n", "x" }, desc = "Add to AI chat" },
      { "<leader>ap", "<cmd>CodeCompanionActions<cr>", mode = { "n", "x" }, desc = "AI actions" },
      {
        "<leader>aug",
        function()
          require("codecompanion").chat {
            user_prompt = "Write a conventional commit message for these changes. Return only the commit message. #{diff}",
          }
        end,
        desc = "Generate commit message with Codex",
      },
    },
    opts = {
      display = {
        chat = {
          window = {
            opts = {
              number = false,
              relativenumber = false,
            },
          },
        },
      },
      adapters = {
        acp = {
          codex = function()
            return require("codecompanion.adapters").extend("codex", {
              commands = {
                default = {
                  "env",
                  'CODEX_CONFIG={"model":"gpt-6-luna","model_reasoning_effort":"xhigh"}',
                  "codex-acp",
                },
              },
              defaults = {
                auth_method = "chat-gpt",
              },
            })
          end,
        },
      },
      interactions = {
        chat = {
          adapter = "codex",
          opts = {
            completion_provider = "blink",
          },
          slash_commands = {
            file = {
              opts = { provider = "snacks" },
            },
          },
          keymaps = {
            send = { modes = { i = { "<C-CR>", "<C-s>" } } },
            completion = { modes = { i = "<C-x>" } },
            close = { modes = { n = "<C-c>", i = "<C-c>" } },
            stop = { modes = { n = "<Esc>" } },
          },
        },
      },
    },
    config = function(_, opts)
      require("codecompanion").setup(opts)

      local handles = {}
      vim.api.nvim_create_autocmd("User", {
        group = vim.api.nvim_create_augroup("CodeCompanionFidget", { clear = true }),
        pattern = { "CodeCompanionRequestStarted", "CodeCompanionRequestFinished" },
        callback = function(event)
          local data = event.data or {}
          local id = data.id
          if not id then
            return
          end

          if event.match == "CodeCompanionRequestStarted" then
            if handles[id] then
              handles[id]:finish()
            end
            local adapter = data.adapter or {}
            handles[id] = require("fidget.progress").handle.create {
              title = "Thinking...",
              message = adapter.model,
              lsp_client = { name = "CodeCompanion (" .. (adapter.formatted_name or "Codex") .. ")" },
            }
          elseif handles[id] then
            handles[id]:report { message = data.status or "Finished" }
            handles[id]:finish()
            handles[id] = nil
          end
        end,
      })
    end,
  },
}
