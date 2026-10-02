return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    dashboard = { enabled = false },
    explorer = { enabled = false },
    indent = { enabled = false },
    input = { enabled = true },
    notifier = {
      enabled = true,
      timeout = 2000,
    },
    picker = {
      enabled = true,
      hidden = true,
      ignored = true,
      sources = {
        explorer = {
          layout = { preview = "main" },
        },
        -- files = {
        --   hidden = true,
        --   ignored = false,
        --   args = {
        --     "--glob",
        --     "!{node_modules,build,dist,.git}",
        --   },
        -- },
        -- grep = {
        --   args = {
        --     "--glob",
        --     "!{node_modules,build,dist,package-lock.json}",
        --   },
        -- },
      },
      actions = {
        opencode_send = function(picker)
          local selected = picker:selected { fallback = true }
          if selected and #selected > 0 then
            local files = {}
            for _, item in ipairs(selected) do
              if item.file then
                table.insert(files, item.file)
              end
            end
            picker:close()

            require("opencode.core").open {
              new_session = false,
              focus = "input",
              start_insert = true,
            }

            local context = require "opencode.context"
            for _, file in ipairs(files) do
              context.add_file(file)
            end
          end
        end,
      },
      win = {
        input = {
          keys = {
            ["<C-o>"] = { "opencode_send", mode = { "n", "i" } },
          },
        },
      },
    },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = false },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    rename = { enabled = true },
    styles = {
      notification = {
        wo = { wrap = true }, -- Wrap notifications
      },
    },
    terminal = {
      enabled = true,
    },
  },
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Setup some globals for debugging (lazy-loaded)
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd -- Override print to use snacks for `:=` command

        -- Create some toggle mappings
        Snacks.toggle.option("spell", { name = "Spelling" }):map "<leader>us"
        Snacks.toggle.option("wrap", { name = "Wrap" }):map "<leader>uw"
        Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map "<leader>uL"
        Snacks.toggle.diagnostics():map "<leader>ud"
        Snacks.toggle.line_number():map "<leader>ul"
        Snacks.toggle
          .option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
          :map "<leader>uc"
        Snacks.toggle.treesitter():map "<leader>ut"
        Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map "<leader>ub"
        Snacks.toggle.inlay_hints():map "<leader>ui"
        Snacks.toggle.indent():map "<leader>ug"
        Snacks.toggle.dim():map "<leader>uD"
      end,
    })
  end,
  keys = {
    {
      "<leader>un",
      function()
        Snacks.notifier.hide()
      end,
      desc = "Dismiss All Notifications",
    },
    {
      "<leader>bd",
      function()
        Snacks.bufdelete()
      end,
      desc = "Delete Buffer",
    },
    {
      "<leader>vl",
      function()
        Snacks.lazygit()
      end,
      desc = "Lazygit",
    },
    {
      "<leader>hB",
      function()
        Snacks.gitbrowse()
      end,
      desc = "Git Browse",
    },
    {
      "<leader>cR",
      function()
        Snacks.rename.rename_file()
      end,
      desc = "Rename File",
    },
    -- Top Pickers & Explorer
    {
      "<leader>fp",
      function()
        Snacks.picker.files()
      end,
      desc = "Find Files",
    },
    {
      "<leader>fs",
      function()
        Snacks.picker.smart()
      end,
      desc = "Smart Find Files",
    },
    {
      "<leader>fb",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Buffers",
    },
    {
      "<leader>uh",
      function()
        Snacks.picker.command_history()
      end,
      desc = "Command History",
    },
    {
      "<leader>fn",
      function()
        Snacks.picker.notifications()
      end,
      desc = "Notification History",
    },
    {
      "<leader>fb",
      function()
        Snacks.picker.buffers {}
      end,
      desc = "Buffers",
    },
    {
      "<leader>fo",
      function()
        Snacks.picker.recent {}
      end,
      desc = "Recent",
    },
    {
      "<leader>/",
      function()
        Snacks.picker.lines()
      end,
      desc = "Buffer Lines",
    },
    {
      "<leader>fl",
      function()
        Snacks.picker.grep_buffers()
      end,
      desc = "Grep Open Buffers",
    },
    {
      "<leader>fw",
      function()
        Snacks.picker.grep()
      end,
      desc = "Grep",
    },
    {
      "<leader>fg",
      function()
        require("snacks").picker("grep", {
          args = {
            "--hidden",
            "--glob",
            "!**/node_modules/*",
            "--glob",
            "!**/.git/*",
            "--glob",
            "!**/.gradle/*",
          },
          live = true,
        })
      end,
      desc = "Live grep",
    },
    {
      "<leader>*",
      function()
        Snacks.picker.grep_word {}
      end,
      desc = "Visual selection or word",
      mode = { "n", "x" },
    },
    {
      "<leader>ff",
      function()
        Snacks.picker.resume()
      end,
      desc = "Resume",
    },
    {
      "<leader>fh",
      function()
        Snacks.picker.command_history()
      end,
      desc = "Command History",
    },
    {
      "<leader>fc",
      function()
        Snacks.picker.commands()
      end,
      desc = "Commands",
    },
    {
      "<leader>ft",
      function()
        Snacks.picker.treesitter { layout = { preset = "ivy" } }
      end,
      desc = "Treesitter",
    },
    {
      "<leader>fa",
      function()
        Snacks.picker.files {
          hidden = true,
          ignored = true,
        }
      end,
      desc = "Search all (ignore and hidden)",
    },

    -- LSP
    {
      "gd",
      function()
        Snacks.picker.lsp_definitions { layout = { preset = "ivy" } }
      end,
      desc = "Goto Definition",
    },
    {
      "gD",
      function()
        Snacks.picker.lsp_declarations { layout = { preset = "ivy" } }
      end,
      desc = "Goto Declaration",
    },
    {
      "grr",
      function()
        Snacks.picker.lsp_references {
          layout = { preset = "ivy" },
        }
      end,
      nowait = true,
      desc = "References",
    },
    {
      "gri",
      function()
        Snacks.picker.lsp_implementations {
          layout = { preset = "ivy" },
        }
      end,
      desc = "Goto Implementation",
    },
    {
      "gry",
      function()
        Snacks.picker.lsp_type_definitions { layout = { preset = "ivy" } }
      end,
      desc = "Goto T[y]pe Definition",
    },
    {
      "<leader>wb",
      function()
        Snacks.picker.lsp_symbols { layout = { preset = "ivy" } }
      end,
      desc = "LSP Symbols",
    },
    {
      "<leader>ww",
      function()
        Snacks.picker.lsp_workspace_symbols { layout = { preset = "ivy" } }
      end,
      desc = "LSP Workspace Symbols",
    },
    {
      "<leader>el",
      function()
        Snacks.picker.diagnostics { layout = { preset = "ivy" } }
      end,
      desc = "Diagnostics",
    },
    {
      "<leader>eb",
      function()
        Snacks.picker.diagnostics_buffer { layout = { preset = "ivy" } }
      end,
      desc = "Buffer Diagnostics",
    },
  },
}
