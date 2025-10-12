-- Bootstrap Lazy.nvim (plugin manager)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Load plugins
require("core.init")

-- Lazy.nvim plugin setup
local lazy = require("lazy")
local mason = require("plugins.mason")
local telescope = require("plugins.telescope")
local nvimtree = require("plugins.nvim-tree")
local tabby = require("plugins.tabby")
local supermaven_ai = require("plugins.ai")
local cmp = require("plugins.cmp")

-- Setup specs
mason.setup()
telescope.setup()
nvimtree.setup()
tabby.setup()
supermaven_ai.setup()
cmp.setup()

lazy.setup({
  mason.core,
  mason.lsp,
  telescope.spec,
  telescope.fzf_native,
  nvimtree.spec,
  tabby.spec,
  supermaven_ai.spec,
  cmp.spec,
})

