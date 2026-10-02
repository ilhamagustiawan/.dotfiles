return {
  "jiaoshijie/undotree",
  opts = {
    -- your options
    window = {
      winblend = 0,
      border = "rounded", -- The string values are the same as those described in 'winborder'.
    },
  },
  keys = { -- load the plugin only when using its keybinding:
    { "<leader>fu", "<cmd>lua require('undotree').toggle()<cr>" },
  },
}
