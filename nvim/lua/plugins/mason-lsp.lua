local M = {}

function M.setup()
  M.spec = {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local format_group = vim.api.nvim_create_augroup("LspFormatOnSave", { clear = true })
      local mason = require("mason")
      local mason_lsp = require("mason-lspconfig")
      local lspconfig = require("lspconfig")
      local cmp_nvim_lsp = require("cmp_nvim_lsp")

      mason.setup()
      -- when enabled it loads two instances of gopls
      --[[ mason_lsp.setup({
        ensure_installed = {
          "gopls",
          "lua_ls",
          "pyright",
          "html",
          "cssls",
          "yamlls",
        },
      }) ]]

      local capabilities = cmp_nvim_lsp.default_capabilities()

      local on_attach = function(client, bufnr)
        -- keymaps
        local opts = { buffer = bufnr, silent = true }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

        -- ✅ FORMAT ON SAVE
        if client.server_capabilities.documentFormattingProvider then
          vim.api.nvim_clear_autocmds({
            group = format_group,
            buffer = bufnr,
          })

          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({
                async = false,
                timeout_ms = 2000,
              })
            end,
          })
        end
      end


      -- ✅ Go
      lspconfig.gopls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          gopls = {
            gofumpt = true,
            staticcheck = true,
          },
        },
      })

      -- Lua
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
          },
        },
      })

      -- Python
      lspconfig.pyright.setup({
        capabilities = capabilities,
        on_attach = on_attach,
      })
    end,
  }

  return M
end

return M
