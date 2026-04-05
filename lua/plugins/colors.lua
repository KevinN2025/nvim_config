return {
  {
    "loctvl842/monokai-pro.nvim",
    config = function()
      require("monokai-pro").setup({
        transparent_background = false,
        terminal_colors = true,
        styles = {
          comment = { italic = true },
          keyword = { italic = true },
        },
        filter = "machine",
      })
    end,
  },

  {
    "ficcdaf/ashen.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("ashen").setup({
        transparent = true,
        italic_comments = true,
      })
      vim.cmd("colorscheme ashen")
    end,
  },
}
