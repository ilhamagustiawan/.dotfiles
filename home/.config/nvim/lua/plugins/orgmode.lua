return {
  "nvim-orgmode/orgmode",
  event = "VeryLazy",
  enabled = false,
  ft = { "org" },
  config = function()
    -- Setup orgmode
    require("orgmode").setup {}
  end,
}
