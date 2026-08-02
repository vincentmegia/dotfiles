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

-----------------------------------------------------------
-- 🩺 Diagnostics
-----------------------------------------------------------
map("n", "<leader>dd", "<cmd>TinyInlineDiag toggle<cr>", { desc = "Toggle Diagnostics" })
map("n", "<leader>dc", "<cmd>TinyInlineDiag toggle_cursor_only<cr>", { desc = "Toggle Cursor-only Diagnostics" })
map("n", "<leader>dr", "<cmd>TinyInlineDiag reset<cr>", { desc = "Reset Diagnostics" })

-----------------------------------------------------------
-- 🖥️ Terminal command → new buffer
-----------------------------------------------------------
map("n", "<leader>sh", function()
  vim.ui.input({ prompt = "Shell command: " }, function(cmd)
    if not cmd or cmd == "" then return end
    vim.cmd("new")
    vim.cmd("setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nonumber norelativenumber")
    local buf = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_option(buf, "filetype", "terminal")
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, { "$ " .. cmd, "" })
    vim.api.nvim_buf_set_option(buf, "modifiable", true)
    vim.cmd("normal! G")
    vim.api.nvim_buf_set_option(buf, "modifiable", false)
    vim.cmd("startinsert")
    local ctx = { buf = buf, cmd = cmd }
    vim.system({ "sh", "-c", cmd .. " 2>&1" }, {
      text = true,
      stdout = function(err, chunk)
        if err or not chunk then return end
        vim.schedule(function()
          vim.api.nvim_buf_set_option(ctx.buf, "modifiable", true)
          local lines = vim.split(chunk, "\n", { plain = true })
          -- Remove trailing empty string from split if chunk ends with newline
          if #lines > 0 and lines[#lines] == "" and chunk:sub(-1) == "\n" then
            lines[#lines] = nil
          end
          if #lines > 0 then
            local start_line = vim.api.nvim_buf_line_count(ctx.buf)
            vim.api.nvim_buf_set_lines(ctx.buf, start_line, -1, false, lines)
          end
          vim.api.nvim_buf_set_option(ctx.buf, "modifiable", false)
          local line_count = vim.api.nvim_buf_line_count(ctx.buf)
          vim.api.nvim_win_set_cursor(0, { line_count, 0 })
        end)
      end,
      on_exit = function(result)
        vim.schedule(function()
          if result.code ~= 0 then
            vim.notify("Command exited with code " .. result.code, vim.log.levels.WARN)
          end
          vim.api.nvim_buf_set_option(ctx.buf, "modifiable", true)
          local start_line = vim.api.nvim_buf_line_count(ctx.buf)
          vim.api.nvim_buf_set_lines(ctx.buf, start_line, -1, false, { "", "[Done]" })
          vim.api.nvim_buf_set_option(ctx.buf, "modifiable", false)
          local line_count = vim.api.nvim_buf_line_count(ctx.buf)
          vim.api.nvim_win_set_cursor(0, { line_count, 0 })
        end)
      end,
    })
  end)
end, { desc = "Run command in new buffer" })
