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
-- opt.foldmethod = 'expr'
-- opt.foldexpr = 'nvim_treesitter#foldexpr()'

-- autocomplete features
opt.completeopt = { 'menuone', 'noselect', 'noinsert' }
-- end settings

local keymap = vim.keymap
keymap.set('n', '<leader>pv', vim.cmd.Ex)
--remap hjkl+ctrl to move in insert mode and normal mode
keymap.set('i', '<C-h>', '<Left>')
keymap.set('i', '<C-j>', '<Down>')
keymap.set('i', '<C-k>', '<Up>')
keymap.set('i', '<C-l>', '<Right>')

-- workspace level
vim.wo.number = true

-- commands
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]
