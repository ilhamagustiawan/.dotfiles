return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "j-hui/fidget.nvim",
        opts = {},
      },
      {
        "fatih/vim-go",
        ft = "go",
        config = function()
          -- we disable most of these features because treesitter and nvim-lsp
          -- take care of it
          vim.g["go_gopls_enabled"] = 0
          vim.g["go_code_completion_enabled"] = 0
          vim.g["go_fmt_autosave"] = 0
          vim.g["go_imports_autosave"] = 0
          vim.g["go_mod_fmt_autosave"] = 0
          vim.g["go_doc_keywordprg_enabled"] = 0
          vim.g["go_def_mapping_enabled"] = 0
          vim.g["go_textobj_enabled"] = 0
          vim.g["go_list_type"] = "quickfix"

          -- run :GoBuild or :GoTestCompile based on the go file
          local function build_go_files()
            if vim.endswith(vim.api.nvim_buf_get_name(0), "_test.go") then
              vim.cmd "GoTestCompile"
            else
              vim.cmd "GoBuild"
            end
          end

          vim.keymap.set("n", "<leader>tb", build_go_files)
        end,
      },
      -- {
      --   "luckasRanarison/tailwind-tools.nvim",
      --   name = "tailwind-tools",
      --   build = ":UpdateRemotePlugins",
      --   dependencies = {
      --     "nvim-treesitter/nvim-treesitter",
      --     "nvim-telescope/telescope.nvim", -- optional
      --     "neovim/nvim-lspconfig", -- optional
      --   },
      --   opts = {}, -- your configuration
      -- },
      "rshkarin/mason-nvim-lint",
      "b0o/schemastore.nvim",
    },
  },
}
