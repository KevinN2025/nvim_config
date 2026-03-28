return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "SmiteshP/nvim-navic",
      "williamboman/mason-lspconfig.nvim",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local navic = require("nvim-navic")
      local mason_lspconfig = require("mason-lspconfig")

      local on_attach = function(client, bufnr)
        if client.server_capabilities.documentSymbolProvider then
          navic.attach(client, bufnr)
        end

        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        map("n", "gd", vim.lsp.buf.definition, "LSP definition")
        map("n", "gr", vim.lsp.buf.references, "LSP references")
        map("n", "K", vim.lsp.buf.hover, "LSP hover")
        map("n", "<leader>rn", vim.lsp.buf.rename, "LSP rename")
        map("n", "<leader>ca", vim.lsp.buf.code_action, "LSP code action")
        map("n", "[d", vim.diagnostic.goto_prev, "Previous diagnostic")
        map("n", "]d", vim.diagnostic.goto_next, "Next diagnostic")
      end

      vim.diagnostic.config({
        severity_sort = true,
        float = { border = "rounded", source = "if_many" },
        underline = true,
        signs = true,
        virtual_text = {
          spacing = 2,
          source = "if_many",
        },
      })

      local default_server_config = {
        capabilities = capabilities,
        on_attach = on_attach,
      }

      local function configure_server(server_name, config)
        vim.lsp.config(server_name, vim.tbl_deep_extend("force", default_server_config, config or {}))
      end

      local function setup_lua_ls()
        configure_server("lua_ls", {
          settings = {
            Lua = {
              runtime = { version = "LuaJIT" },
              diagnostics = { globals = { "vim" } },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
              },
              telemetry = { enable = false },
            },
          },
        })
      end

      local installed_servers = {}
      if mason_lspconfig.get_installed_servers then
        installed_servers = mason_lspconfig.get_installed_servers()
      end

      for _, server_name in ipairs(installed_servers) do
        if server_name == "lua_ls" then
          setup_lua_ls()
        else
          configure_server(server_name)
        end

        vim.lsp.enable(server_name)
      end

      if vim.fn.executable("lua-language-server") == 1 and not vim.tbl_contains(installed_servers, "lua_ls") then
        setup_lua_ls()
        vim.lsp.enable("lua_ls")
      end
    end,
  },
}
