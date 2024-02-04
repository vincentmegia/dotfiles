local config = {
  cmd = { '/opt/homebrew/bin/jdtls' },
  root_dir = vim.fs.dirname(vim.fs.find({ 'gradlew', '.git', 'mvnw' }, { upward = true })[1]),
}
require('jdtls').start_or_attach(config)

local bo = vim.bo

bo.tabstop = 4
bo.shiftwidth = 4
bo.expandtab = true
bo.softtabstop = 4
