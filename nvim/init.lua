-- Bootstrap Lazy.nvim (plugin manager)
--
local orig_deprecate = vim.deprecate

vim.deprecate = function(name, alternative, version, plugin)
  -- Ignore only the lspconfig framework warning
  if name:find("lspconfig", 1, true) then
    return
  end

  orig_deprecate(name, alternative, version, plugin)
end

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
local mason_lsp = require("plugins.mason-lsp")
local telescope = require("plugins.telescope")
local nvimtree = require("plugins.nvim-tree")
local tabby = require("plugins.tabby")
local supermaven_ai = require("plugins.ai")
local cmp = require("plugins.cmp")
local comment = require("plugins.comment")
local notify = require("plugins.notify")
local noice = require("plugins.noice")

-- Setup specs
mason.setup()
telescope.setup()
nvimtree.setup()
tabby.setup()
supermaven_ai.setup()
cmp.setup()
mason_lsp.setup()
comment.setup()
notify.setup()
noice.setup()

lazy.setup({
  mason.spec,
  mason_lsp.spec,
  telescope.spec,
  telescope.fzf_native,
  nvimtree.spec,
  tabby.spec,
  supermaven_ai.spec,
  cmp.spec,
  comment.spec,
  notify.spec,
  noice.spec,
})

vim.cmd("colorscheme onedark")
vim.g.have_nerd_font = true
vim.opt.clipboard = "unnamedplus"
vim.g.python3_host_prog = "/Users/vincem/.config/nvim/venv/bin/python" -- For init.lua
vim.g.loaded_perl_provider = 0
