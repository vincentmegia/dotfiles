
-- Basic Neovim settings
vim.o.number = true
vim.o.relativenumber = true
vim.o.termguicolors = true
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
-- Remove ~ at the end of buffer
vim.o.fillchars = "eob: "  -- sets the end-of-buffer character to blank
-- Highlight the current line
vim.o.cursorline = true

-- Always show sign column (for LSP/GitSigns)
vim.o.signcolumn = "yes"
vim.o.showtabline = 2
