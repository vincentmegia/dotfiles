local M = {}

function M.setup()
  M.spec_mason = {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = true,
  }

  M.spec_mason_lsp = {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      local ok, mason_lspconfig = pcall(require, "mason-lspconfig")
      if not ok then return end

      mason_lspconfig.setup({
        ensure_installed = { "pyright", "lua_ls" },
        automatic_installation = true,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

      local function on_attach(_, bufnr)
        local opts = { buffer = bufnr, silent = true }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
      end

      -- Python LSP
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "python",
        callback = function()
          vim.lsp.start({
            name = "pyright",
            cmd = { "pyright-langserver", "--stdio" },
            root_dir = vim.fs.root_pattern("pyproject.toml", "setup.py", ".git")(),
            on_attach = on_attach,
            capabilities = capabilities,
          })
        end,
      })

      -- Lua LSP
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "lua",
        callback = function()
          vim.lsp.start({
            name = "lua_ls",
            cmd = { "lua-language-server" },
            root_dir = vim.fs.root_pattern(".git", ".luarc.json")(),
            settings = {
              Lua = {
                diagnostics = { globals = { "vim" } },
                workspace = { checkThirdParty = false },
              },
            },
            on_attach = on_attach,
            capabilities = capabilities,
          })
        end,
      })
    end,
  }

  return M
end

return M

