-- ~/.config/nvim/lua/plugins/nvim-tree.lua
local M = {}

function M.setup()
  M.spec = {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    version = "*",
    config = function()
      local tree = require("nvim-tree")
      local api = require("nvim-tree.api")

      -- NvimTree setup
      tree.setup({
        update_focused_file = { enable = true, update_root = true },
        view = { width = 35, side = "left", preserve_window_proportions = true },
        renderer = { highlight_opened_files = "all", icons = { show = { file = true, folder = true, git = true } } },
        hijack_cursor = true,
      })

      -- Auto open NvimTree on VimEnter if no file given
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          if vim.fn.argc() == 0 then
            api.tree.open()
          end
        end,
      })

      -- Auto open NvimTree in new tabs
      vim.api.nvim_create_autocmd("TabNewEntered", { callback = function() api.tree.open() end })

      -- Focus current buffer in tree
      vim.keymap.set("n", "<leader>f", function()
        api.tree.focus()
        api.tree.find_file(vim.fn.expand("%:p"))
      end, { desc = "Focus Current Buffer in NvimTree" })
      --
    end,
  }

  return M
end

return M

