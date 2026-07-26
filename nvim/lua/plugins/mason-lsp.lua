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
      local mason_lsp = require("mason-lspconfig")
      local lspconfig = require("lspconfig")
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local mason = require("mason")

      mason_lsp.setup({
        ensure_installed = {
          "gopls",
          "lua_ls",
          "pyright",
          "html",
          "cssls",
          "yamlls",
          "jsonls",
          "rust_analyzer",
        },
      })

      require("mason").setup({
        ensure_installed = { "rustfmt" },
      })

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
            group = format_group,
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

      -- Rust
      lspconfig.rust_analyzer.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          ["rust-analyzer"] = {
            rustfmt = {
              allFeatures = true,
            },
            cargo = {
              allFeatures = true,
            },
          },
        },
      })

      -- JSON
      lspconfig.jsonls.setup({
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          json = {
            format = {
              enable = true,
            },
          },
        },
      })

      -- Rust format on save (rustfmt directly)
      local rustfmt_group = vim.api.nvim_create_augroup("RustFmtOnSave", { clear = true })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = rustfmt_group,
        pattern = "*.rs",
        callback = function()
          if vim.fn.executable("rustfmt") == 1 then
            local buf = vim.api.nvim_get_current_buf()
            local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
            local input = table.concat(lines, "\n") .. "\n"
            local result = vim.fn.system({ "rustfmt" }, input)
            if vim.v.shell_error == 0 then
              local formatted_lines = vim.split(result, "\n")
              if formatted_lines[#formatted_lines] == "" then
                formatted_lines[#formatted_lines] = nil
              end
              vim.api.nvim_buf_set_lines(buf, 0, -1, false, formatted_lines)
              vim.api.nvim_buf_set_option(buf, "modified", false)
            end
          end
        end,
      })
    end,
  }

  return M
end

return M
