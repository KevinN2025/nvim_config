return {
  {
    "loctvl842/monokai-pro.nvim",
    config = function()
      require("monokai-pro").setup({
        transparent_background = true,
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
    "cocopon/iceberg.vim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme iceberg")
      vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
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
      -- vim.cmd("colorscheme ashen")
    end,
  },
}
