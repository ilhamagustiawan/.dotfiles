return {
  "rebelot/kanagawa.nvim",
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
  opts = {
    compile = true, -- enable compiling the colorscheme
    undercurl = true, -- enable undercurls
    transparent = false, -- do not set background color
    dimInactive = false, -- dim inactive window `:h hl-NormalNC`
    theme = "dragon", -- Load "wave" theme when 'background' option is not set
    colors = {
      palette = {
        -- change all usages of these colors

        -- fujiWhite = "#fbf1c7",
        -- oldWhite = "#ebdbb2",
        dragonBlack3 = "#0a0a0a", -- match Atom terminal bg
        dragonBlack0 = "#070707", -- darker panels/floats
        dragonBlack4 = "#1e2023", -- cursorline/lighter bg
      },
      theme = {
        all = {
          ui = {
            bg_gutter = "NONE",
          },
        },
      },
    },
    overrides = function(colors)
      local theme = colors.theme

      return {
        -- https://github.com/rebelot/kanagawa.nvim?tab=readme-ov-file#transparent-floating-windows
        NormalFloat = { bg = "NONE" },
        FloatBorder = { bg = "NONE" },
        FloatTitle = { bg = "NONE" },

        -- Save an hlgroup with dark background and dimmed foreground
        -- so that you can use it where your still want darker windows.
        -- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
        NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },

        -- Popular plugins that open floats will link to NormalFloat by default;
        -- set their background accordingly if you wish to keep them dark and borderless
        LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
        MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },

        Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 }, -- add `blend = vim.o.pumblend` to enable transparency
        PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
        PmenuSbar = { bg = theme.ui.bg_m1 },
        PmenuThumb = { bg = theme.ui.bg_p2 },
        WinSeparator = { fg = theme.syn.identifier },

        -- SnacksNotifier
        SnacksNotifierBorderError = { link = "DiagnosticError" },
        SnacksNotifierBorderWarn = { link = "DiagnosticWarn" },
        SnacksNotifierBorderInfo = { link = "DiagnosticInfo" },
        SnacksNotifierBorderDebug = { link = "Debug" },
        SnacksNotifierBorderTrace = { link = "Comment" },
        SnacksNotifierIconError = { link = "DiagnosticError" },
        SnacksNotifierIconWarn = { link = "DiagnosticWarn" },
        SnacksNotifierIconInfo = { link = "DiagnosticInfo" },
        SnacksNotifierIconDebug = { link = "Debug" },
        SnacksNotifierIconTrace = { link = "Comment" },
        SnacksNotifierTitleError = { link = "DiagnosticError" },
        SnacksNotifierTitleWarn = { link = "DiagnosticWarn" },
        SnacksNotifierTitleInfo = { link = "DiagnosticInfo" },
        SnacksNotifierTitleDebug = { link = "Debug" },
        SnacksNotifierTitleTrace = { link = "Comment" },
        SnacksNotifierError = { link = "DiagnosticError" },
        SnacksNotifierWarn = { link = "DiagnosticWarn" },
        SnacksNotifierInfo = { link = "DiagnosticInfo" },
        SnacksNotifierDebug = { link = "Debug" },
        SnacksNotifierTrace = { link = "Comment" },

        -- SnacksProfiler
        SnacksProfilerIconInfo = { bg = theme.ui.bg_search, fg = theme.syn.fun },
        SnacksProfilerBadgeInfo = { bg = theme.ui.bg_visual, fg = theme.syn.fun },
        SnacksScratchKey = { link = "SnacksProfilerIconInfo" },
        SnacksScratchDesc = { link = "SnacksProfilerBadgeInfo" },
        SnacksProfilerIconTrace = { bg = theme.syn.fun, fg = theme.ui.float.fg_border },
        SnacksProfilerBadgeTrace = { bg = theme.syn.fun, fg = theme.ui.float.fg_border },
        SnacksIndent = { fg = theme.ui.bg_p2, nocombine = true },
        SnacksIndentScope = { fg = theme.ui.pmenu.bg, nocombine = true },
        SnacksZenIcon = { fg = theme.syn.statement },
        SnacksInputIcon = { fg = theme.ui.pmenu.bg },
        SnacksInputBorder = { fg = theme.syn.identifier },
        SnacksInputTitle = { fg = theme.syn.identifier },

        -- SnacksPicker
        SnacksPickerInputBorder = { fg = theme.syn.constant },
        SnacksPickerInputTitle = { fg = theme.syn.constant },
        SnacksPickerBoxTitle = { fg = theme.syn.constant },
        SnacksPickerSelected = { fg = theme.syn.number },
        SnacksPickerToggle = { link = "SnacksProfilerBadgeInfo" },
        SnacksPickerPickWinCurrent = { fg = theme.ui.fg, bg = theme.syn.number, bold = true },
        SnacksPickerPickWin = { fg = theme.ui.fg, bg = theme.ui.bg_search, bold = true },
      }
    end,
  },
}
