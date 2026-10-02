return {
  {
    "tpope/vim-fugitive",
    cmd = { "G", "Git", "GBrowse", "Gdiffsplit", "Gvdiffsplit" },
    dependencies = {
      "tpope/vim-rhubarb",
      "shumphrey/fugitive-gitlab.vim",
    },
    keys = {
      {
        "<leader>vv",
        "<cmd>Git<CR>",
        { silent = false },
      },
      {
        "<leader>vp",
        "<cmd>Git push<CR>",
        { silent = false },
      },
    },
  },
  {
    "NeogitOrg/neogit",
    lazy = true,
    dependencies = {
      "nvim-lua/plenary.nvim", -- required
      "esmuellert/codediff.nvim", -- optional
      "isakbm/gitgraph.nvim",
      "folke/snacks.nvim", -- optional
    },
    opts = {
      auto_show_console = true,
      console_timeout = 100000,
      disable_insert_on_commit = true,
      graph_style = "kitty",
      diff_viewer = "codediff",
      integrations = {
        snacks = true,
        codediff = true,
      },
    },
    keys = {
      {
        "<leader>vn",
        "<cmd>Neogit<CR>",
        { silent = false },
      },
    },
  },

  {
    "lewis6991/gitsigns.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "linrongbin16/gitlinker.nvim",
        cmd = "GitLink",
        opts = {},
        keys = {
          { "<leader>ho", "<cmd>GitLink!<cr>", mode = { "n", "v" }, desc = "Open git link" },
        },
      },
    },
    config = function()
      local function wrap(f, ...)
        local args = { ... }
        local nargs = select("#", ...)
        return function()
          f(unpack(args, 1, nargs))
        end
      end

      require("gitsigns").setup {
        signs = {
          add = { text = "┃" },
          change = { text = "┃" },
          delete = { text = "_" },
          topdelete = { text = "‾" },
          changedelete = { text = "~" },
          untracked = { text = "┆" },
        },
        signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
        numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
        linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
        word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
        watch_gitdir = {
          follow_files = true,
        },
        auto_attach = true,
        attach_to_untracked = false,
        current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = "right_align", -- 'eol' | 'overlay' | 'right_align'
          delay = 1000,
          ignore_whitespace = false,
          virt_text_priority = 100,
          use_focus = true,
        },
        current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil, -- Use default
        max_file_length = 40000, -- Disable if file is longer than this (in lines)
        preview_config = {
          border = "rounded",
        },
        on_attach = function(bufnr)
          local gs = package.loaded.gitsigns

          local function map(mode, l, r, opts)
            opts = opts or {}
            opts.buffer = bufnr
            vim.keymap.set(mode, l, r, opts)
          end

          -- Navigation
          map("n", "]c", function()
            if vim.wo.diff then
              return "]c"
            end
            vim.schedule(function()
              gs.next_hunk()
            end)
            return "<Ignore>"
          end, { expr = true })

          map("n", "[c", function()
            if vim.wo.diff then
              return "[c"
            end
            vim.schedule(function()
              gs.prev_hunk()
            end)
            return "<Ignore>"
          end, { expr = true })

          map("n", "<leader>hs", gs.stage_hunk)
          map("n", "<leader>hr", gs.reset_hunk)
          map("v", "<leader>hs", function()
            gs.stage_hunk { vim.fn.line ".", vim.fn.line "v" }
          end)
          map("v", "<leader>hr", function()
            gs.reset_hunk { vim.fn.line ".", vim.fn.line "v" }
          end)
          map("n", "<leader>hS", gs.stage_buffer)
          map("n", "<leader>hu", gs.undo_stage_hunk)
          map("n", "<leader>hR", gs.reset_buffer)
          map("n", "<leader>hp", gs.preview_hunk)
          map("n", "<leader>hi", gs.preview_hunk_inline)
          map("n", "<leader>hb", wrap(gs.blame_line, { full = true }))
          map("n", "<leader>hd", gs.diffthis)
          map("n", "<leader>hD", function()
            gs.diffthis "~"
          end)

          -- Toggles
          map("n", "<leader>hm", gs.toggle_current_line_blame)
          map("n", "<leader>hx", gs.toggle_deleted)
          map("n", "<leader>hw", gs.toggle_word_diff)

          map("n", "<leader>hQ", wrap(gs.setqflist, "all"))
          map("n", "<leader>hq", gs.setqflist)

          -- Text object
          vim.keymap.set({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<cr>")
        end,
      }
    end,
  },
}
