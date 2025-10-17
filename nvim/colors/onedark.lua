-- onedark.lua — A clean, elegant One Dark theme for Neovim
-- Author: ChatGPT (Vincent’s custom)

local colors = {
  bg        = "#282C34",
  bg_high   = "#2C323C",
  fg        = "#ABB2BF",
  red       = "#E06C75",
  green     = "#98C379",
  yellow    = "#E5C07B",
  blue      = "#61AFEF",
  magenta   = "#C678DD",
  cyan      = "#56B6C2",
  gray      = "#5C6370",
  dark_gray = "#3E4452",
  orange    = "#D19A66",
  black     = "#1E222A",
}

vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") then
  vim.cmd("syntax reset")
end
vim.o.termguicolors = true
vim.g.colors_name = "onedark"

-- Basic Editor
vim.api.nvim_set_hl(0, "Normal",          { fg = colors.fg, bg = colors.bg })
vim.api.nvim_set_hl(0, "NormalFloat",     { fg = colors.fg, bg = colors.bg_high })
vim.api.nvim_set_hl(0, "CursorLine",      { bg = colors.dark_gray })
vim.api.nvim_set_hl(0, "CursorLineNr",    { fg = colors.yellow, bold = true })
vim.api.nvim_set_hl(0, "LineNr",          { fg = colors.gray })
vim.api.nvim_set_hl(0, "Visual",          { bg = colors.dark_gray })
vim.api.nvim_set_hl(0, "StatusLine",      { fg = colors.fg, bg = colors.bg_high })
vim.api.nvim_set_hl(0, "StatusLineNC",    { fg = colors.gray, bg = colors.bg_high })
vim.api.nvim_set_hl(0, "VertSplit",       { fg = colors.dark_gray })

-- Tabs
vim.api.nvim_set_hl(0, "TabLine",         { fg = colors.gray, bg = colors.bg_high })
vim.api.nvim_set_hl(0, "TabLineSel",      { fg = colors.bg, bg = colors.blue, bold = true })
vim.api.nvim_set_hl(0, "TabLineFill",     { fg = colors.gray, bg = colors.bg })
vim.api.nvim_set_hl(0, "TabLineHead",     { fg = colors.green, bg = colors.bg, bold = true })
vim.api.nvim_set_hl(0, "TabLineTail",     { fg = colors.red, bg = colors.bg, bold = true })

-- Syntax
vim.api.nvim_set_hl(0, "Comment",         { fg = colors.gray, italic = true })
vim.api.nvim_set_hl(0, "Constant",        { fg = colors.cyan })
vim.api.nvim_set_hl(0, "String",          { fg = colors.green })
vim.api.nvim_set_hl(0, "Identifier",      { fg = colors.blue })
vim.api.nvim_set_hl(0, "Statement",       { fg = colors.magenta })
vim.api.nvim_set_hl(0, "Keyword",         { fg = colors.magenta, bold = true })
vim.api.nvim_set_hl(0, "Function",        { fg = colors.yellow })
vim.api.nvim_set_hl(0, "Type",            { fg = colors.orange })
vim.api.nvim_set_hl(0, "Number",          { fg = colors.cyan })
vim.api.nvim_set_hl(0, "Operator",        { fg = colors.fg })
vim.api.nvim_set_hl(0, "PreProc",         { fg = colors.yellow })

-- Diagnostics
vim.api.nvim_set_hl(0, "DiagnosticError", { fg = colors.red })
vim.api.nvim_set_hl(0, "DiagnosticWarn",  { fg = colors.yellow })
vim.api.nvim_set_hl(0, "DiagnosticInfo",  { fg = colors.blue })
vim.api.nvim_set_hl(0, "DiagnosticHint",  { fg = colors.cyan })

-- Treesitter (for better syntax)
vim.api.nvim_set_hl(0, "@function",       { fg = colors.yellow })
vim.api.nvim_set_hl(0, "@variable",       { fg = colors.fg })
vim.api.nvim_set_hl(0, "@keyword",        { fg = colors.magenta })
vim.api.nvim_set_hl(0, "@string",         { fg = colors.green })
vim.api.nvim_set_hl(0, "@comment",        { fg = colors.gray, italic = true })

-- Plugins
vim.api.nvim_set_hl(0, "NvimTreeNormal",  { fg = colors.fg, bg = colors.bg })
vim.api.nvim_set_hl(0, "NvimTreeFolderName", { fg = colors.blue })
vim.api.nvim_set_hl(0, "NvimTreeOpenedFolderName", { fg = colors.cyan, bold = true })
vim.api.nvim_set_hl(0, "NvimTreeRootFolder", { fg = colors.orange, bold = true })
vim.api.nvim_set_hl(0, "NvimTreeIndentMarker", { fg = colors.gray })
vim.api.nvim_set_hl(0, "NvimTreeExecFile", { fg = colors.green, bold = true })

vim.api.nvim_set_hl(0, "GitSignsAdd",     { fg = colors.green })
vim.api.nvim_set_hl(0, "GitSignsChange",  { fg = colors.yellow })
vim.api.nvim_set_hl(0, "GitSignsDelete",  { fg = colors.red })

vim.api.nvim_set_hl(0, "TelescopeBorder", { fg = colors.blue })
vim.api.nvim_set_hl(0, "TelescopePrompt", { fg = colors.fg, bg = colors.bg_high })

-- Popup menu
vim.api.nvim_set_hl(0, "Pmenu",           { fg = colors.fg, bg = colors.bg_high })
vim.api.nvim_set_hl(0, "PmenuSel",        { fg = colors.bg, bg = colors.blue })
vim.api.nvim_set_hl(0, "PmenuSbar",       { bg = colors.bg_high })
vim.api.nvim_set_hl(0, "PmenuThumb",      { bg = colors.gray })
