-- ~/.config/nvim/lua/plugins/mason.lua
local M = {}

function M.setup()
  -- Mason core plugin
  M.core = {
    "williamboman/mason.nvim",
    config = true,
  }

  -- Mason LSP bridge (ensures servers installed)
  M.lsp = {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      local mason_lspconfig = require("mason-lspconfig")

      -- Ensure servers are installed
      mason_lspconfig.setup({
        ensure_installed = { "pyright", "lua_ls" },
        automatic_installation = true,
      })

      -- on_attach function for LSP keymaps
      local function on_attach(_, bufnr)
        local opts = { buffer = bufnr, silent = true }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
      end

      -- LSP capabilities (for cmp_nvim_lsp)
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      if cmp_ok then
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
      end

      -- Pyright server config
      local pyright_config = {
        name = "pyright",
        cmd = { "pyright-langserver", "--stdio" },
        on_attach = on_attach,
        capabilities = capabilities,
        root_dir = vim.fs.root(0, { "pyproject.toml", "setup.py", ".git" }),
      }

      -- Lua LS server config
      local lua_ls_config = {
        name = "lua_ls",
        cmd = { "lua-language-server" },
        on_attach = on_attach,
        capabilities = capabilities,
        root_dir = vim.fs.root(0, { ".git", ".luarc.json" }),
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
          },
        },
      }

      -- Autostart servers for respective filetypes
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "python",
        callback = function()
          vim.lsp.start(pyright_config)
        end,
      })

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "lua",
        callback = function()
          vim.lsp.start(lua_ls_config)
        end,
      })
    end,
  }
end

return M

