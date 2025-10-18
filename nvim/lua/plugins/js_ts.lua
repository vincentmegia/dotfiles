-- ~/.config/nvim/lua/plugins/js_ts.lua
local M = {}

function M.setup()
  M.spec = {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
      if not lspconfig_ok then
        vim.notify("nvim-lspconfig not found", vim.log.levels.ERROR)
        return
      end

      local cmp_ok, cmp = pcall(require, "cmp")
      local luasnip_ok, luasnip = pcall(require, "luasnip")
      if cmp_ok and luasnip_ok then
        require("luasnip.loaders.from_vscode").lazy_load()
        cmp.setup({
          snippet = {
            expand = function(args)
              luasnip.lsp_expand(args.body)
            end,
          },
          mapping = cmp.mapping.preset.insert({
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            ["<Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              else
                fallback()
              end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, { "i", "s" }),
          }),
          sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "luasnip" },
            { name = "buffer" },
            { name = "path" },
          }),
        })
      end

      -- Mason setup
      local mason_ok, mason = pcall(require, "mason")
      if mason_ok then
        mason.setup()
      end

      local mason_lsp_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
      if mason_lsp_ok then
        mason_lspconfig.setup({ ensure_installed = { "tsserver", "eslint" }, automatic_installation = true })
      end

      -- Helper function for on_attach
      local on_attach = function(client, bufnr)
        local opts = { buffer = bufnr, silent = true }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

        -- Inlay hints toggle
        local inlay_enabled = true
        if client.server_capabilities.inlayHintProvider then
          vim.lsp.inlay_hint(bufnr, inlay_enabled)
        end
        vim.keymap.set("n", "<leader>ih", function()
          inlay_enabled = not inlay_enabled
          vim.lsp.inlay_hint(bufnr, inlay_enabled)
          local msg = inlay_enabled and "Inlay hints enabled" or "Inlay hints disabled"
          vim.notify(msg, vim.log.levels.INFO)
        end, { buffer = bufnr, desc = "Toggle Inlay Hints" })
      end

      -- LSP servers
      local servers = { "tsserver", "eslint" }
      for _, server in ipairs(servers) do
        if lspconfig[server] then
          lspconfig[server].setup({
            on_attach = on_attach,
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
          })
        end
      end
    end,
  }

  return M
end

return M
