-- ~/.config/nvim/lua/core/signs.lua
local M = {}

-- ==============================
-- 1. LSP Diagnostic Icons (Gutter)
-- ==============================
local devicons_ok, devicons = pcall(require, "nvim-web-devicons")

-- Diagnostic icons (from nerd font)
local diag_icons = {
  Error = "",
  Warn  = "",
  Info  = "",
  Hint  = "",
}

-- Use nvim-web-devicons diagnostic icons if available
if devicons_ok then
  local icons = devicons.icons
  if icons.diagnostics then
    if icons.diagnostics.Error then
      diag_icons.Error = icons.diagnostics.Error.glyph or diag_icons.Error
    end
    if icons.diagnostics.Warn then
      diag_icons.Warn = icons.diagnostics.Warn.glyph or diag_icons.Warn
    end
    if icons.diagnostics.Hint then
      diag_icons.Hint = icons.diagnostics.Hint.glyph or diag_icons.Hint
    end
    if icons.diagnostics.Info then
      diag_icons.Info = icons.diagnostics.Info.glyph or diag_icons.Info
    end
  end
end

-- Define signs with proper Neovim 0.12 API (text must be a string)
vim.fn.sign_define("DiagnosticSignError", { text = diag_icons.Error, hl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn",  { text = diag_icons.Warn,  hl = "DiagnosticSignWarn"  })
vim.fn.sign_define("DiagnosticSignInfo",  { text = diag_icons.Info,  hl = "DiagnosticSignInfo"  })
vim.fn.sign_define("DiagnosticSignHint",  { text = diag_icons.Hint,  hl = "DiagnosticSignHint"  })

-- Configure diagnostics: icons in left gutter + virtual text inlay (no icons)
vim.diagnostic.config({
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = diag_icons.Error,
      [vim.diagnostic.severity.WARN] = diag_icons.Warn,
      [vim.diagnostic.severity.INFO] = diag_icons.Info,
      [vim.diagnostic.severity.HINT] = diag_icons.Hint,
    },
  },
  virtual_text = {
    prefix = "",
    spacing = 2,
  },
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
