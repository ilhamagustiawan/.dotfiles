local languages = {
  "rust",
  "zig",
  "lua",
  "bash",
  "c",
  "diff",
  "html",
  "jsdoc",
  "json",
  "luadoc",
  "luap",
  "markdown",
  "markdown_inline",
  "printf",
  "python",
  "query",
  "regex",
  "toml",
  "jsx",
  "tsx",
  "javascript",
  "typescript",
  "svelte",
  "vim",
  "vimdoc",
  "xml",
  "yaml",
  "json5",
  "prisma",
  "sql",
  "css",
  "scss",
  "astro",
  "go",
  "gomod",
  "http",
  "gitignore",
  "gitcommit",
  "git_config",
  "git_rebase",
  "gdscript",
  "godot_resource",
  "gdshader",
  "comment",
  "fish",
  "latex",
  "make",
  "typst",
  "vue",
}

local ignore_filetypes = {
  "checkhealth",
  "lazy",
  "mason",
  "snacks_dashboard",
  "snacks_notif",
  "snacks_win",
  "csv",
  "norg",
}

return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false,
  branch = "main",
  dependencies = {
    {
      "nvim-treesitter/nvim-treesitter-context",
      opts = true,
    },
    {
      "windwp/nvim-ts-autotag",
      config = function()
        require("nvim-ts-autotag").setup { enable = true }
      end,
    },
  },
  config = function()
    -- replicate `ensure_installed`, runs asynchronously, skips existing languages
    require("nvim-treesitter").install(languages)

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("treesitter.setup", {}),
      callback = function(args)
        local buf = args.buf
        local filetype = args.match

        if vim.tbl_contains(ignore_filetypes, filetype) then
          return
        end

        local language = vim.treesitter.language.get_lang(filetype) or filetype
        if not vim.treesitter.language.add(language) then
          return
        end

        vim.treesitter.start(buf, language)

        vim.wo.foldmethod = "expr"
        vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
