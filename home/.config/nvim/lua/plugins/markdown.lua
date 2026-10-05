return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "Avante", "chat-dialog", "copilot-chat", "opencode_output", "codecompanion" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- Mandatory
      "nvim-tree/nvim-web-devicons", -- Optional but recommended
    },
    opts = {
      file_types = { "Avante", "chat-dialog", "copilot-chat", "opencode_output", "codecompanion" },
      anti_conceal = { enabled = false },
      heading = {
        enabled = true,
        sign = false,
        icons = { "󰬺 ", "󰬻 ", "󰬼 ", "󰬽 ", "󰬾 ", "󰬿 " },
        position = "inline", -- Place icon inline instead of overlay
        width = "block", -- Background only for the heading text, not full width
        min_width = 80, -- Minimum width for consistency
        left_margin = 0, -- Remove any indentation
        left_pad = 1, -- Small padding around the icon
        right_pad = 1, -- Small padding around the icon
      },
      code = {
        enabled = true,
        sign = false,
        style = "full",
        -- left_pad = 1,
        -- right_pad = 1,
        -- border = "thin",
        language_pad = 1,
        position = "left",
        width = "block",
        left_pad = 1,
        right_pad = 1,
        border = "thick",
      },
      bullet = {
        enabled = true,
        icons = { "●", "○", "◆", "◇" },
      },
      checkbox = {
        enabled = true,
      },
      quote = { enabled = true, icon = "▎" },
      pipe_table = { enabled = true, style = "full" },
      callout = {
        note = { raw = "[!NOTE]", rendered = " Note", highlight = "RenderMarkdownInfo" },
        tip = { raw = "[!TIP]", rendered = " Tip", highlight = "RenderMarkdownSuccess" },
        important = { raw = "[!IMPORTANT]", rendered = " Important", highlight = "RenderMarkdownHint" },
        warning = { raw = "[!WARNING]", rendered = " Warning", highlight = "RenderMarkdownWarn" },
        caution = { raw = "[!CAUTION]", rendered = " Caution", highlight = "RenderMarkdownError" },
      },
    },
    keys = {
      { "<leader>mr", "<cmd>RenderMarkdown toggle<cr>", desc = "Render Markdown Toggle", ft = "markdown" },
    },
  },
}
