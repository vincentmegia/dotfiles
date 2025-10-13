local M = {}

function M.setup()
  M.spec = {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    version = "*",
    cmd = "NvimTreeToggle",
    config = function()
      local tree = require("nvim-tree")
      local api = require("nvim-tree.api")

      -- === NvimTree Setup ===
      tree.setup({
        update_focused_file = { enable = true, update_root = true },
        view = {
          width = 35,
          side = "left",
          preserve_window_proportions = true,
        },
        renderer = {
          highlight_opened_files = "all",
          icons = { show = { file = true, folder = true, git = true } },
        },
        hijack_cursor = true,

        -- ✅ Correct way to define custom keymaps
        on_attach = function(bufnr)
          local api = require("nvim-tree.api")

          -- remove default Enter mapping (important!)
          pcall(vim.keymap.del, "n", "<CR>", { buffer = bufnr })

          -- define our custom <CR> mapping
          vim.keymap.set("n", "<CR>", function()
            local node = api.tree.get_node_under_cursor()
            if not node or not node.absolute_path then
              vim.notify("[nvim-tree] No file selected", vim.log.levels.WARN)
              return
            end

            local path = vim.fn.fnameescape(node.absolute_path)
            vim.notify("Opening in new tab: " .. path)
            vim.cmd("tabnew " .. path)

            -- keep tree open in the left side
            api.tree.focus()
          end, { buffer = bufnr, noremap = true, silent = true, desc = "Open file in new tab" })

          -- optional: key to refocus tree
          vim.keymap.set("n", "<leader>f", function()
            api.tree.focus()
            api.tree.find_file(vim.fn.expand("%:p"))
          end, { buffer = bufnr, noremap = true, silent = true, desc = "Focus current file in tree" })
        end,
      })

      -- === Auto open NvimTree if no file is given ===
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          if vim.fn.argc() == 0 then
            api.tree.open()
          end
        end,
      })

      -- === Keep tree open in new tabs ===
      vim.api.nvim_create_autocmd("TabNewEntered", {
        callback = function()
          api.tree.open()
        end,
      })
    end,
  }

  return M
end

return M
