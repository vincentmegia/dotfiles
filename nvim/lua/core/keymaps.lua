-- ~/.config/nvim/lua/core/keymaps.lua
-- Centralized keymaps for Neovim

local map = vim.keymap.set -- vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-----------------------------------------------------------
-- 💾 General / Quality of Life
-----------------------------------------------------------
map("n", "<leader>w", "<cmd>w<cr>", { desc = "Save File" })
map("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
map("n", "<leader>h", "<cmd>nohlsearch<cr>", { desc = "Clear Highlights" })
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })
map("n", "<leader>p", '"+p', { desc = "Paste from system clipboard" })
map("n", "<leader>Q", "<cmd>wa | qa<CR>", { desc = "Save All and Quit" })
map("n", "<leader>wQ", "<cmd>wa | qa<CR>", { desc = "Save All and Quit" })
-- TABS
-- Next tab
map("n", "<leader>]", ":tabnext<CR>", { desc = "Next Tab" })
-- Previous tab
map("n", "<leader>[", ":tabprevious<CR>", { desc = "Previous Tab" })
-- Close current tab
map("n", "<leader>q", ":tabclose<CR>", { desc = "Close Tab" })

-----------------------------------------------------------
-- 🗂️ File Explorer
-----------------------------------------------------------
-- Explorer
map("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle File Explorer" })
map("n", "<leader>f", function()
  local api = require("nvim-tree.api")
  local file = vim.fn.expand("%:p")
  api.tree.focus()
  api.tree.find_file(file)
end, { desc = "Focus Current Buffer in NvimTree" })

-----------------------------------------------------------
-- 🔍 Telescope
-----------------------------------------------------------
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Find Files" })
map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", { desc = "Live Grep" })
map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", { desc = "List Buffers" })
map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", { desc = "Help Tags" })
map("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", { desc = "Document Symbols" })
map("n", "<leader>fw", "<cmd>Telescope lsp_workspace_symbols<cr>", { desc = "Workspace Symbols" })

-----------------------------------------------------------
-- 🧠 LSP Keymaps
-----------------------------------------------------------
-- Use autocommand to only set LSP keys when an LSP attaches
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local buf = args.buf
    local function bufmap(mode, lhs, rhs, desc)
      map(mode, lhs, rhs, { buffer = buf, desc = desc, noremap = true, silent = true })
    end

    bufmap("n", "gd", vim.lsp.buf.definition, "Go to Definition")
    bufmap("n", "gr", vim.lsp.buf.references, "Find References")
    bufmap("n", "K", vim.lsp.buf.hover, "Hover Info")
    bufmap("n", "<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
    bufmap("n", "<leader>ca", vim.lsp.buf.code_action, "Code Action")
    bufmap("n", "[d", vim.diagnostic.goto_prev, "Previous Diagnostic")
    bufmap("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")
    bufmap("n", "<leader>de", vim.diagnostic.open_float, "Show diagnostic")
  end,
})


-----------------------------------------------------------
-- 🧠 Lazy
-----------------------------------------------------------
map("n", "<leader>ls", "<cmd>Lazy sync<cr>", { desc = "Lazy Sync" })


-- Move cursor in insert mode using Ctrl + keys
map('i', '<C-h>', '<Left>', { desc = 'Move left in insert mode' })
map('i', '<C-l>', '<Right>', { desc = 'Move right in insert mode' })
map('i', '<C-j>', '<Down>', { desc = 'Move down in insert mode' })
map('i', '<C-k>', '<Up>', { desc = 'Move up in insert mode' })

-- go
map("n", "<leader>gr", function()
  -- runs /lua/go/run.lua
  require("go.run").go_run()
end, { desc = "Go Run (reuse terminal)" })

-- Go test
map("n", "<leader>tf", ":GoTestFunc<CR>", { desc = "Go test function", silent = true })
map("n", "<leader>tt", ":GoTestPkg<CR>", { desc = "Go test package", silent = true })
map("n", "<leader>ta", ":GoTest<CR>", { desc = "Go test all", silent = true })

-- Go Build
map("n", "<leader>grb", function()
  -- runs /lua/go/build.lua
  require("go.build").go_build()
end, { desc = "Go Run build(reuse terminal)" })
