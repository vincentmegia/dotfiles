vim.g.mapleader = ' '

local opt = vim.opt

-- settings
opt.autoindent = true
opt.smartindent = true

opt.expandtab = true
opt.tabstop = 2
opt.wrap = false
opt.shiftwidth = 2
opt.signcolumn = "yes"
opt.termguicolors = true
opt.swapfile = false
opt.backspace = 'indent,eol,start'
opt.background = 'dark'


-- autocomplete features
opt.completeopt = { 'menuone', 'noselect', 'noinsert' }
-- end settings

local keymap = vim.keymap
keymap.set('n', '<leader>pv', vim.cmd.Ex)

-- workspace level
vim.wo.number = true

