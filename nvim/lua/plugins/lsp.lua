-- ~/.config/nvim/lua/plugins/lsp.lua
local M = {}

function M.setup()
  -- Safely require dependencies
  local ok_mason, mason_lspconfig = pcall(require, "mason-lspconfig")
  local ok_lsp, lspconfig = pcall(require, "lspconfig")
  if not ok_mason or not ok_lsp then
    vim.notify("mason-lspconfig or lspconfig not found", vim.log.levels.ERROR)
    return
  end

  -- Ensure LSP servers are installed (use lspconfig server names!)
  mason_lspconfig.setup({
    ensure_installed = { "pyright", "lua_ls" },
    automatic_installation = true,
  })

  -- LSP keymaps on attach
  local function on_attach(_, bufnr)
    local opts = { buffer = bufnr, silent = true }
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
    vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  end

  -- LSP capabilities for nvim-cmp
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  local ok_cmp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
  if ok_cmp then
    capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
  end

  -- LSP server configurations
  local servers = {
    pyright = {
      on_attach = on_attach,
      capabilities = capabilities,
      root_dir = vim.fs.root(0, { "pyproject.toml", "setup.py", ".git" }),
    },
    lua_ls = {
      on_attach = on_attach,
      capabilities = capabilities,
      root_dir = vim.fs.root(0, { ".git", ".luarc.json" }),
      settings = {
        Lua = {
          diagnostics = { globals = { "vim" } },
          workspace = { checkThirdParty = false },
        },
      },
    },
  }

  -- Autostart servers based on filetype
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function() vim.lsp.start(servers.pyright) end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "lua",
    callback = function() vim.lsp.start(servers.lua_ls) end,
  })
end

return M

