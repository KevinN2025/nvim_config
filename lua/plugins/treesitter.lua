return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",

  event = { "BufReadPost", "BufNewFile" }, -- 👈 IMPORTANT

  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = { "lua", "go", "rust", "c", "cpp", "java", "python" },
      highlight = { enable = true },
    })
  end,
}
