return {
  'williamboman/mason.nvim',
  dependencies = {
    'williamboman/mason-lspconfig.nvim',
  },
  opts = function()
    -- import mason
    local mason = require('mason')
    -- import mason-lspconfig
    local mason_lspconfig = require('mason-lspconfig')

    -- enable mason and configure icons
    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗"
        }
      }
    })

    mason_lspconfig.setup({
      -- list of servers for mason install
      ensure_installed = {
        'tsserver',
        'html',
        'cssls',
        'tailwindcss',
        'lua_ls',
        'gopls',
        'jdtls',
      },
      -- auto-install configured servers (with lspconfig)
      automatic_installation = true, -- not the same as ensure_installed
    })
  end,
}
