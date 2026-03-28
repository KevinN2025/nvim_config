return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    require("trouble").setup({})

    vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", {
      desc = "Diagnostics",
    })
    vim.keymap.set("n", "<leader>xq", "<cmd>Trouble qflist toggle<cr>", {
      desc = "Quickfix",
    })
  end,
}
