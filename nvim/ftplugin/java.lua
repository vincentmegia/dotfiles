local config = {
  cmd = { '/opt/homebrew/bin/jdtls' },
  root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1]),
  on_attach = function()
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = "" })
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "" })
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = "" })
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = "" })
  end
}
require('jdtls').start_or_attach(config)

local bo = vim.bo

bo.tabstop = 4
bo.shiftwidth = 4
bo.expandtab = true
bo.softtabstop = 4
