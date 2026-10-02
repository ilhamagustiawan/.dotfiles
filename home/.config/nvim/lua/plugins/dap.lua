return {
  "mfussenegger/nvim-dap",
  dependencies = {
    {
      "theHamsta/nvim-dap-virtual-text",
      config = true,
    },
    {
      "rcarriga/nvim-dap-ui",
      dependencies = {
        "mfussenegger/nvim-dap",
        "nvim-neotest/nvim-nio",
      },
      opts = {
        icons = { expanded = "", collapsed = "", circular = "" },
        mappings = {
          -- Use a table to apply multiple mappings
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        layouts = {
          {
            elements = {
              -- Provide IDs as strings or tables with "id" and "size" keys
              {
                id = "scopes",
                size = 0.25,
              },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              { id = "repl", size = 0.45 },
              { id = "console", size = 0.55 },
            },
            size = 0.10,
            position = "bottom",
          },
        },
        floating = {
          max_height = 0.9,
          max_width = 0.5, -- Floats will be treated as percentage of your screen.
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
      },
    },
    -- { "LiadOz/nvim-dap-repl-highlights", opts = {} },
    {
      "leoluz/nvim-dap-go",
      config = function()
        require("dap-go").setup {
          dap_configurations = {
            {
              -- Must be "go" or it will be ignored by the plugin
              type = "go",
              name = "Attach remote",
              mode = "remote",
              request = "attach",
            },
            {
              name = "Launch Package (workspace folder)",
              type = "go",
              request = "launch",
              program = "${workspaceFolder}",
            },
          },
        }
      end,
    },
    { "stevearc/overseer.nvim" },
  },
  keys = {
    {
      "<leader>db",
      function()
        require("dap").toggle_breakpoint()
      end,
      desc = "Toggle breakpoint",
    },
    {
      "<leader>dc",
      function()
        require("dap").set_breakpoint(vim.fn.input "Breakpoint condition: ")
      end,
      desc = "Breakpoint condition",
    },
    {
      "<leader>dl",
      function()
        require("dap").run_last()
      end,
      desc = "Breakpoint run last",
    },
    {
      "<leader>do",
      function()
        require("dap").run_to_cursor()
      end,
      desc = "Breakpoint run last",
    },
    {
      "<leader>dm",
      function()
        require("dap").set_breakpoint(nil, nil, vim.fn.input "Log point message: ")
      end,
      desc = "Breakpoint message",
    },
    {
      "<leader>dk",
      function()
        require("dapui").eval()
      end,
      desc = "Eval",
      mode = { "n", "v" },
    },
    {
      "<leader>dj",
      function()
        require("dap").step_over()
      end,
      desc = "Step over",
    },
    {
      "<leader>dn",
      function()
        require("dap").continue()
      end,
      desc = "Continue",
    },
    {
      "<F5>",
      function()
        require("dap").continue()
      end,
      desc = "Continue",
    },
    {
      "<F3>",
      function()
        require("dap").terminate()
      end,
      desc = "Breakpoint terminate",
    },
    {
      "<F10>",
      function()
        require("dap").step_over()
      end,
      desc = "Step over",
    },
    {
      "<F11>",
      function()
        require("dap").step_into()
      end,
      desc = "Step into",
    },
    {
      "<F12>",
      function()
        require("dap").step_out()
      end,
      desc = "Step Out",
    },
  },
  config = function()
    -- Use overseer for running preLaunchTask and postDebugTask.
    require("overseer").enable_dap(true)
    require("dap.ext.vscode").json_decode = require("overseer.json").decode

    local dap, dapui = require "dap", require "dapui"

    local function close()
      dapui.close()
      require("nvim-dap-virtual-text").refresh()
    end

    -- Attach DAP UI to DAP events
    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = close
    dap.listeners.before.event_exited.dapui_config = close

    dap.listeners.on_session["dapui_config"] = function(_, new_session)
      if not new_session then
        close()
      end
    end

    vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })

    vim.api.nvim_create_user_command("DapBreakpoints", function()
      dap.list_breakpoints()
    end, { nargs = 0 })

    vim.api.nvim_create_user_command("DapClearBreakPoints", function()
      dap.clear_breakpoints()
    end, { nargs = 0 })

    vim.api.nvim_create_user_command("DapUIToggle", function()
      require("dapui").toggle()
    end, { nargs = 0 })

    vim.fn.sign_define("DapBreakpoint", { text = " ", texthl = "Special", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointCondition", { text = " ", texthl = "Special", linehl = "", numhl = "" })
    vim.fn.sign_define("DapLogPoint", { text = "⁋ ", texthl = "Special", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = " ", texthl = "Special", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointRejected", { text = "X", texthl = "DiagnosticError", linehl = "", numhl = "" })
  end,
}
