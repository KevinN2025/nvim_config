-- =====================
-- Basic Settings
-- =====================
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.clipboard = "unnamedplus"
vim.opt.termguicolors = true

-- =====================
-- Bootstrap Lazy.nvim
-- =====================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- =====================
-- Plugin Setup (Lazy)
-- =====================
require("lazy").setup({

  -- Monokai Pro colorscheme
  {
    "loctvl842/monokai-pro.nvim",
    config = function()
      require("monokai-pro").setup({
        transparent_background = true,
        terminal_colors = true,
        devicons = true,
        styles = {
          comment = { italic = true },
          keyword = { italic = true },
        },
        filter = "machine", -- options: classic | octagon | pro | machine | ristretto | spectrum
      })
      vim.cmd("colorscheme monokai-pro")
    end,
  },

  -- Statusline
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "monokai-pro",
          icons_enabled = true,
          section_separators = "",
          component_separators = "",
        },
      })
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "go", "rust", "c", "cpp", "java", "python" },
        highlight = { enable = true },
      })
    end,
  },

  -- Completion
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
      })
    end,
  },

  -- Neo-tree (File Explorer)
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,
        popup_border_style = "rounded",
        filesystem = {
          filtered_items = {
            visible = true, -- show hidden files
            hide_dotfiles = false,
            hide_gitignored = true,
          },
          follow_current_file = { enabled = true },
          group_empty_dirs = true,
          hijack_netrw_behavior = "open_default",
        },
        window = {
          width = 30,
          mappings = {
            ["<space>"] = "toggle_node",
            ["l"] = "open",
            ["h"] = "close_node",
            ["q"] = "close_window",
          },
        },
      })
    end,
  },

  -- Barbecue.nvim (breadcrumbs in winbar)
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      show_dirname = true,
      show_basename = true,
      show_modified = true,
      symbols = {
        modified = "●",
        ellipsis = "…",
        separator = "",
      },
    },
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.5",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          layout_config = { prompt_position = "top" },
          sorting_strategy = "ascending",
          prompt_prefix = "🔍 ",
          selection_caret = " ",
        },
      })
      telescope.load_extension("fzf")

      -- Keymaps
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
    end,
  },

  -- LSP
  {
    "neovim/nvim-lspconfig",
    dependencies = { "SmiteshP/nvim-navic" },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local navic = require("nvim-navic")

      local on_attach = function(client, bufnr)
        if client.server_capabilities.documentSymbolProvider then
          navic.attach(client, bufnr)
        end
      end

      -- Go
      lspconfig.gopls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        cmd = { "gopls" },
      })

      -- Rust
      lspconfig.rust_analyzer.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        cmd = { "rust-analyzer" },
      })

      -- C / C++
      lspconfig.clangd.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        cmd = { "clangd" },
      })

      -- Java
      lspconfig.jdtls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        cmd = { "jdtls" },
        root_dir = lspconfig.util.root_pattern(".git", "mvnw", "gradlew", "pom.xml", "build.gradle"),
      })

      -- Python
      lspconfig.basedpyright.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        cmd = { "basedpyright-langserver", "--stdio" },
      })
    end,
  },
})

-- =====================
-- Keymaps
-- =====================
-- Open Neo-tree
vim.keymap.set("n", "<leader>e", ":Neotree filesystem reveal left<CR>", { noremap = true, silent = true })
