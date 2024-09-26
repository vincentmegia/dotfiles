return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'hrsh7th/cmp-nvim-lsp',
    { 'antosha417/nvim-lsp-file-operations', config = true },
  },
  config = function()
    -- define global icons
    local iconsDap = require("stupendousware.icons").dap
    local iconsDiagnostics = require("stupendousware.icons").diagnostics
    vim.fn.sign_define('DapBreakpoint', { text = iconsDap.Breakpoint, texthl = '', linehl = '', numhl = '' })
    vim.fn.sign_define('DiagnosticSignError', { text = iconsDiagnostics.Error, texthl = 'DiagnosticSignError' })
    vim.fn.sign_define('DiagnosticSignWarn', { text = iconsDiagnostics.Warn, texthl = 'DiagnosticSignWarn' })
    vim.fn.sign_define('DiagnosticSignInfo', { text = iconsDiagnostics.Info, texthl = 'DiagnosticSignInfo' })
    vim.fn.sign_define('DiagnosticSignHint', { text = iconsDiagnostics.Hint, texthl = 'DiagnosticSignHint' })

    vim.api.nvim_create_autocmd({ "BufWritePre" }, { pattern = { "*.templ" }, callback = vim.lsp.buf.format })
    vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'single' })
    -- setup diagnostics icons
    local icons = require("stupendousware.icons").diagnostics
    vim.diagnostic.config({
      severity_sort = true,
      virtual_text = false,
      float = { border = 'single' },
      jump = {
        _highest = true,
      },
      -- commented, not working
      --[[ signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = icons.Error,
          [vim.diagnostic.severity.WARN] = icons.Warn,
          [vim.diagnostic.severity.INFO] = icons.Info,
          [vim.diagnostic.severity.HINT] = icons.Hint,
        },
      }, ]]
    })

    -- setup neodev before lspconfig
    -- IMPORTANT: make sure to setup neodev BEFORE lspconfig
    require("neodev").setup({
      -- add any options here, or leave empty to use the default settings
      library = { plugins = { "nvim-dap-ui" }, types = true },
    })

    -- import lspconfig plugin
    local lsp_config = require('lspconfig')
    -- import cmp-nvim-lsp plugin
    local cmp_nvim_lsp = require('cmp_nvim_lsp')

    local keymap = vim.keymap
    local on_attach = function(_, bufnr)
      local opts = { noremap = true, silent = true, buffer = bufnr }
      local lspbuf = vim.lsp.buf
      local diagnostics = vim.diagnostic

      -- set base keybindings
      -- set keybindings
      opts.desc = 'Show LSP References'
      keymap.set('n', 'gR', '<cmd>Telescope lsp_references<CR>', opts)

      opts.desc = 'Go to declaration'
      keymap.set('n', 'gD', lspbuf.declaration, opts)

      opts.desc = 'Show LSP Definitions'
      keymap.set('n', 'gd', '<cmd>Telescope lsp_definitions<CR>', opts)

      opts.desc = 'Show LSP Implementations'
      keymap.set('n', 'gi', '<cmd>Telescope lsp_implementations<CR>', opts)

      opts.desc = 'Show LSP Type Definitions'
      keymap.set('n', 'gt', '<cmd>Telescope lsp_type_definitions<CR>', opts)

      opts.desc = 'See Available Code Actions'
      keymap.set({ 'n', 'v' }, '<leader>ca', lspbuf.code_action, opts)

      opts.desc = 'Smart Rename'
      keymap.set('n', '<leader>rn', lspbuf.rename, opts)

      opts.desc = 'Show Buffer Diagnostics'
      keymap.set('n', '<leader>D', '<cmd>Telescope diagnostics bufnr=0<CR>', opts)

      opts.desc = 'Show Line Diagnostics'
      keymap.set('n', '<leader>d', diagnostics.open_float, opts)

      opts.desc = 'GoTo Previous Diagnostics'
      keymap.set('n', '[d', diagnostics.goto_prev, opts)

      opts.desc = 'GoTo next Diagnostics'
      keymap.set('n', ']d', diagnostics.goto_next, opts)

      opts.desc = 'Show Documentation for what is under cursor'
      keymap.set('n', 'K', lspbuf.hover, opts)

      opts.desc = 'Restart LSP'
      keymap.set('n', '<leader>rs', '<cmd>LspRestart<CR>', opts)
    end

    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- configure html server
    lsp_config['html'].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      filetypes = { "html", "templ" }
    })

    lsp_config['htmx'].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      filetypes = { "html", "templ" }
    })

    lsp_config['ts_ls'].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
      cmd = { "typescript-language-server", "--stdio" }
    })

    lsp_config['cssls'].setup({
      capabilities = capabilities,
      on_attach = on_attach,
    })

    lsp_config['gopls'].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      cmd = { 'gopls' },
      filetypes = { 'go', 'gomod', 'gowork', 'gotempl', 'templ' },
    })

    lsp_config['templ'].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      filetypes = { 'templ' },
    })

    lsp_config['yamlls'].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      filetypes = { 'yaml' },
    })

    lsp_config['tailwindcss'].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      filetypes = { 'templ', 'astro', 'javascript', 'typescript', 'react' },
    })

    lsp_config['lua_ls'].setup({
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        Lua = {
          -- make the language server recognize vim global
          diagnostics = {
            globals = { 'vim' },
          },
          workspace = {
            -- make the language server aware of runtime files
            library = {
              [vim.fn.expand('$VIMRUNTIME/lua')] = true,
              [vim.fn.stdpath('config') .. '/lua'] = true,
            },
          },
        },
      },
    })
  end,
  --cmd = { "Mason" }
}
