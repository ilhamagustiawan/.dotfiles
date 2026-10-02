-- Find and replace.

-- { '<leader>fr', "<cmd>lua require('spectre').open()<CR><cr>", desc = 'Spectre' },
-- {
--     '<leader>fs',
--     '<cmd>lua require("spectre").open_visual({select_word=true})<CR>',
--     desc = 'Search current word',
--     mode = 'n',
-- },
-- {
--     '<leader>fv',
--     '<esc><cmd>lua require("spectre").open_visual()<CR>',
--     desc = 'Search current word',
--     mode = 'v',
-- },
return {
  {
    "MagicDuck/grug-far.nvim",
    opts = {},
    cmd = "GrugFar",
    keys = {
      {
        "<leader>fr",
        function()
          local grug = require "grug-far"
          grug.open {
            transient = true,
            keymaps = { help = "?" },
          }
        end,
        desc = "GrugFar",
        mode = { "n", "v" },
      },
    },
  },
}
