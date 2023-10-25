return {
  'ray-x/go.nvim',
  dependencies = {
    'ray-x/guihua.lua',
    'neovim/nvim-lspconfig',
    'nvim-treesitter/nvim-treesitter',
    'theHamsta/nvim-dap-virtual-text',
  },
  config = function()
    require('go').setup()
    local format_sync_grp = vim.api.nvim_create_augroup('GoFormat', {})
    vim.api.nvim_create_autocmd('BufWritePre', {
      pattern = '*.go',
      callback = function()
        local goformat = require('go.format')
        goformat.gofmt()
        goformat.goimport()
      end,
      group = format_sync_grp,
    })
  end,
  event = { 'CmdlineEnter' },
  ft = { 'go', 'gomod' },
  build = ':lua require("go.install").update_all_sync()'
}
