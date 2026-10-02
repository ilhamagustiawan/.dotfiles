return {
  {
    "stevearc/oil.nvim",
    opts = {},
    keys = {
      { "<leader>-", "<cmd>Oil<cr>", desc = "Oil" },
    },
    config = function()
      require("oil").setup {
        default_file_explorer = true,
        delete_to_trash = true,
        skip_confirm_for_simple_edits = true,
        buf_options = {
          buflisted = true,
          bufhidden = "hide",
        },
        view_options = {
          show_hidden = true,
          natural_order = true,
          is_always_hidden = function(name, _)
            return name == ".." or name == ".git"
          end,
        },
        win_options = {
          wrap = true,
        },
      }
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    lazy = false,
    keys = {
      { "-", "<cmd>Neotree toggle<cr>", desc = "NeoTree" },
    },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
      {
        "s1n7ax/nvim-window-picker", -- for open_with_window_picker keymaps
        version = "2.*",
        config = function()
          require("window-picker").setup {
            filter_rules = {
              include_current_win = false,
              autoselect_one = true,
              -- filter using buffer options
              bo = {
                -- if the file type is one of following, the window will be ignored
                filetype = { "neo-tree", "neo-tree-popup", "notify" },
                -- if the buffer type is one of following, the window will be ignored
                buftype = { "terminal", "quickfix" },
              },
            },
          }
        end,
      },
    },
    config = function()
      require("neo-tree").setup {
        filesystem = {
          hijack_netrw_behavior = "open_current",
        },
        window = {
          position = "right",
          width = 0.3,
          mappings = {
            ["f"] = "fuzzy_finder",
            ["/"] = "filter_on_submit",
          },
        },
      }
    end,
  },
}
