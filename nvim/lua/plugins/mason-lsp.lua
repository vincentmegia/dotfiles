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
      local mason_ok, mason = pcall(require, "mason")
      local mason_lsp_ok, mason_lsp = pcall(require, "mason-lspconfig")
      local cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")

      if not (mason_ok and mason_lsp_ok) then
        vim.notify("mason or mason-lspconfig not found", vim.log.levels.ERROR)
        return
      end

      mason.setup()
      mason_lsp.setup({
        ensure_installed = { "lua_ls", "pyright", "ts_ls" }, -- note ts_ls (not tsserver)
        automatic_installation = true,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      if cmp_ok then
        capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
      end

      local function on_attach(_, bufnr)
        local opts = { buffer = bufnr, silent = true }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
      end

      --------------------------------------------------------------------
      -- ✅ Detect correct config table for Neovim version
      --------------------------------------------------------------------
      local lspconfig = vim.lsp.configs or vim.lsp._config or {}

      -- Helper to safely define a new server
      local function define_server(name, config)
        if not lspconfig[name] then
          lspconfig[name] = { default_config = config }
        end
      end

      define_server("lua_ls", {
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
          },
        },
      })

      define_server("pyright", {
        cmd = { "pyright-langserver", "--stdio" },
        filetypes = { "python" },
        on_attach = on_attach,
        capabilities = capabilities,
      })

      define_server("ts_ls", {
        cmd = { "typescript-language-server", "--stdio" },
        filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
        on_attach = on_attach,
        capabilities = capabilities,
      })

      --------------------------------------------------------------------
      -- ✅ Start all installed servers automatically
      --------------------------------------------------------------------
      for _, server_name in ipairs(mason_lsp.get_installed_servers()) do
        local cfg = lspconfig[server_name]
        if cfg and cfg.default_config then
          vim.lsp.start(cfg.default_config)
        else
          vim.notify("[mason-lsp] no config for " .. server_name, vim.log.levels.WARN)
        end
      end
    end,
  }

  return M
end

return M
