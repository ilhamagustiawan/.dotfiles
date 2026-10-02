return {
  "mason-org/mason-lspconfig.nvim",
  opts = {},
  dependencies = {
    {
      "mason-org/mason.nvim",
      opts = {
        registries = {
          "github:mason-org/mason-registry",
          "github:Crashdummyy/mason-registry",
        },
      },
    },
    "mfussenegger/nvim-dap",
    { "jay-babu/mason-nvim-dap.nvim" },
    "zapling/mason-conform.nvim",
    "rshkarin/mason-nvim-lint",
    {
      "WhoIsSethDaniel/mason-tool-installer.nvim",
      opts = {
        ensure_installed = {
          "stylua",
        },
      },
    },
  },
}
