return {
  "cbochs/grapple.nvim",
  opts = {
    scope = "git_branch", -- also try out "git_branch"
    icons = false, -- setting to "true" requires "nvim-web-devicons"
    status = false,
  },
  keys = {
    { ",,", "<cmd>Grapple toggle<cr>", desc = "Tag a file" },
    { ",.", "<cmd>Grapple toggle_tags<cr>", desc = "Toggle tags menu" },

    { ",a", "<cmd>Grapple select index=1<cr>", desc = "Select first tag" },
    { ",s", "<cmd>Grapple select index=2<cr>", desc = "Select second tag" },
    { ",d", "<cmd>Grapple select index=3<cr>", desc = "Select third tag" },
    { ",f", "<cmd>Grapple select index=4<cr>", desc = "Select fourth tag" },
    { ",g", "<cmd>Grapple select index=5<cr>", desc = "Select fifth tag" },

    { ",]", "<cmd>Grapple cycle_tags next<cr>", desc = "Go to next tag" },
    { ",[", "<cmd>Grapple cycle_tags prev<cr>", desc = "Go to previous tag" },
  },
}
