return {
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup()
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "gopls",
          "rust_analyzer",
          "clangd",
          "jdtls",
          "basedpyright",
          "intelephense",
          "lua_ls",
        },
        automatic_enable = false,
      })
    end,
  },
}
