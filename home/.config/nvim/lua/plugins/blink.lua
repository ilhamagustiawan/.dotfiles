return {
  "saghen/blink.cmp",
  event = "VimEnter",
  version = "*",
  dependencies = {
    "folke/lazydev.nvim",
    {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    {
      "L3MON4D3/LuaSnip",
      version = "*",
      build = (function()
        if vim.fn.has "win32" == 1 or vim.fn.executable "make" == 0 then
          return
        end
        return "make install_jsregexp"
      end)(),
      dependencies = {},
      opts = {},
    },
  },
  opts = {
    keymap = {
      preset = "enter",
      ["<C-f>"] = {},
      ["<C-y>"] = { "show", "show_documentation", "hide_documentation" },
      ["<C-n>"] = { "select_next", "show", "show_documentation", "fallback_to_mappings" },
      ["<Tab>"] = {
        function(cmp)
          if cmp.snippet_active() then
            return cmp.accept()
          else
            return cmp.select_and_accept()
          end
        end,
        "snippet_forward",
        "fallback",
      },
    },
    appearance = {
      use_nvim_cmp_as_default = false,
      nerd_font_variant = "normal",
    },
    completion = {
      accept = { auto_brackets = { enabled = true } },
      menu = {
        border = "rounded",
        winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:CursorLine,Search:None",
        scrolloff = 1,
        scrollbar = false,
        draw = {
          padding = 0,
          columns = {
            { "kind_icon" },
            { "label", "label_description" },
            { "kind" },
          },
          treesitter = { "lsp" },
        },
      },
      documentation = {
        window = {
          border = "rounded",
          scrollbar = false,
          winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,EndOfBuffer:BlinkCmpDoc",
        },
        auto_show = true,
        auto_show_delay_ms = 500,
      },
      list = {
        selection = {
          preselect = true,
          auto_insert = false,
        },
      },
      ghost_text = { enabled = false },
    },
    signature = { enabled = true, window = { border = "rounded" } },
    snippets = { preset = "luasnip" },
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100,
        },
        cmdline = {
          min_keyword_length = 2,
        },
      },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
    cmdline = {
      enabled = true,
      keymap = {
        preset = "cmdline",
        ["<Right>"] = false,
        ["<Left>"] = false,
        ["<CR>"] = { "accept_and_enter", "fallback" },
      },
      completion = {
        list = { selection = { preselect = false } },
        menu = {
          auto_show = function()
            return vim.fn.getcmdtype() == ":"
          end,
        },
        ghost_text = { enabled = true },
      },
    },
  },
  opts_extend = { "sources.default" },
}
