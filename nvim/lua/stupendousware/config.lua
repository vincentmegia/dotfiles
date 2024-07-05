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
opt.clipboard = 'unnamedplus'
opt.cursorline = true

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
vim.wo.relativenumber = true

-- commands
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]
-- vim.diagnostic.config({
--   virtual_text = false, -- Turn off inline diagnostics
-- })

-- Show all diagnostics on current line in floating window
vim.api.nvim_set_keymap(
  'n', '<Leader>sd', ':lua vim.diagnostic.open_float()<CR>',
  { noremap = true, silent = true }
)
-- Go to next diagnostic (if there are multiple on the same line, only shows
-- one at a time in the floating window)
vim.api.nvim_set_keymap(
  'n', '<Leader>snd', ':lua vim.diagnostic.goto_next()<CR>',
  { noremap = true, silent = true }
)
-- Go to prev diagnostic (if there are multiple on the same line, only shows
-- one at a time in the floating window)
vim.api.nvim_set_keymap(
  'n', '<Leader>spd', ':lua vim.diagnostic.goto_prev()<CR>',
  { noremap = true, silent = true }
)

vim.filetype.add({
  extension = {
    templ = "templ",
  },
})

vim.api.nvim_set_keymap('n', '<Leader>cgt', ":w | :!templ generate <CR>",
  { noremap = true, silent = true })
