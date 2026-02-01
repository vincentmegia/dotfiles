-- ~/.config/nvim/lua/core/signs.lua
local M = {}

-- ==============================
-- 1. LSP Diagnostic Icons (Gutter)
-- ==============================
-- Define icons
local diag_icons = {
  Error = "",
  Warn  = "",
  Info  = "",
  Hint  = "",
}

-- Define signs silently to avoid the deprecation warning
for type, icon in pairs(diag_icons) do
  local hl = "DiagnosticSign" .. type
  vim.cmd(string.format("silent! sign define %s text=%s texthl=%s numhl=", hl, icon, hl))
end

-- Configure diagnostics globally
vim.diagnostic.config({
  virtual_text = {
    prefix = "●", -- small dot
    spacing = 2,
  },
  signs = true, -- show gutter icons
  underline = true,
  severity_sort = false,
  update_in_insert = false,
  float = {
    focusable = false,
    border = "rounded",
    source = "always",
    header = "Diagnostics:",
    prefix = "● ",
    max_width = 80,
    format = function(d)
      -- Show code or source neatly
      local code = d.code or d.source or "?"
      return string.format("[%s] %s", code, d.message)
    end,
  },
})

-- ==============================
-- 2. Buffer / File Status Icons
-- ==============================
local buffer_icons = {
  Modified = { icon = "●", hl = "WarningMsg" },
  ReadOnly = { icon = "🔒", hl = "Comment" },
}

M.buffer_status = function()
  local buf = vim.api.nvim_get_current_buf()
  if vim.bo[buf].modified then
    return buffer_icons.Modified.icon
  elseif not vim.bo[buf].modifiable then
    return buffer_icons.ReadOnly.icon
  end
  return ""
end

-- ==============================
-- 3. GitSigns (Optional)
-- ==============================
local ok, gitsigns = pcall(require, "gitsigns")
if ok then
  gitsigns.setup({
    signs = {
      add          = { text = "➕" },
      change       = { text = "" },
      delete       = { text = "" },
      topdelete    = { text = "" },
      changedelete = { text = "" },
    },
    numhl = false,
    linehl = false,
  })
end

return M
