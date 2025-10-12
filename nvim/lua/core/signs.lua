-- ~/.config/nvim/lua/core/signs.lua
-- Modern icons for buffer, git, and LSP signs

local signs = {
  -- Buffer / file status
  BufferModified = { icon = "●", hl = "WarningMsg" },    -- modified buffer
  BufferReadOnly = { icon = "🔒", hl = "Comment" },     -- read-only buffer

  -- GitSigns
  GitAdd     = { icon = "➕", hl = "GitSignsAdd" },
  GitChange  = { icon = "", hl = "GitSignsChange" },
  GitDelete  = { icon = "", hl = "GitSignsDelete" },

  -- LSP diagnostics
  DiagnosticError   = { icon = "", hl = "DiagnosticError" },
  DiagnosticWarn    = { icon = "", hl = "DiagnosticWarn" },
  DiagnosticInfo    = { icon = "", hl = "DiagnosticInfo" },
  DiagnosticHint    = { icon = "", hl = "DiagnosticHint" },
}

-- Apply buffer / file signs
vim.fn.sign_define("BufferModified", { text = signs.BufferModified.icon, texthl = signs.BufferModified.hl, numhl = "" })
vim.fn.sign_define("BufferReadOnly", { text = signs.BufferReadOnly.icon, texthl = signs.BufferReadOnly.hl, numhl = "" })

-- Apply GitSigns icons (if using lewis6991/gitsigns.nvim)
vim.fn.sign_define("GitSignsAdd",    { text = signs.GitAdd.icon, texthl = signs.GitAdd.hl, numhl = "" })
vim.fn.sign_define("GitSignsChange", { text = signs.GitChange.icon, texthl = signs.GitChange.hl, numhl = "" })
vim.fn.sign_define("GitSignsDelete", { text = signs.GitDelete.icon, texthl = signs.GitDelete.hl, numhl = "" })

-- Apply LSP diagnostic signs
vim.fn.sign_define("DiagnosticSignError",   { text = signs.DiagnosticError.icon, texthl = signs.DiagnosticError.hl, numhl = "" })
vim.fn.sign_define("DiagnosticSignWarn",    { text = signs.DiagnosticWarn.icon, texthl = signs.DiagnosticWarn.hl, numhl = "" })
vim.fn.sign_define("DiagnosticSignInfo",    { text = signs.DiagnosticInfo.icon, texthl = signs.DiagnosticInfo.hl, numhl = "" })
vim.fn.sign_define("DiagnosticSignHint",    { text = signs.DiagnosticHint.icon, texthl = signs.DiagnosticHint.hl, numhl = "" })

-- Optional: always show the sign column
vim.o.signcolumn = "yes"

