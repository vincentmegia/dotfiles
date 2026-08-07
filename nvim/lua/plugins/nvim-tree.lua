local M = {}

function M.setup()
  M.spec = {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    version = "*",
    lazy = false, -- ✅ ensure plugin loads on startup
    priority = 999, -- ✅ load before other UI plugins (optional)
    config = function()
      local ok, tree = pcall(require, "nvim-tree")
      if not ok then
        vim.notify("nvim-tree not found", vim.log.levels.ERROR)
        return
      end

      local api = require("nvim-tree.api")

      -- === NvimTree Setup ===
      tree.setup({
        sync_root_with_cwd = true,
        respect_buf_cwd = false,
        update_focused_file = { enable = true, update_root = false },
        view = {
          width = 35,
          side = "left",
          preserve_window_proportions = true,
        },
        renderer = {
          highlight_opened_files = "all",
          root_folder_label = false,
          icons = {
            webdev_colors = true,
            git_placement = "after",
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
            },
            glyphs = {
              default = "",
              symlink = "",
              folder = {
                arrow_closed = "",
                arrow_open = "",
                default = "",
                open = "",
                empty = "",
                empty_open = "",
                symlink = "",
              },
              git = {
                unstaged = "✗",
                staged = "✓",
                unmerged = "",
                renamed = "➜",
                untracked = "★",
                deleted = "",
                ignored = "◌",
              },
            },
          },
        },
        hijack_cursor = true,
        hijack_unnamed_buffer_when_opening = true,
        filters = {
          dotfiles = false,
          custom = {},
        },
        on_attach = function(bufnr)
          local api = require("nvim-tree.api")

          -- ✅ Set up all default mappings first
          api.config.mappings.default_on_attach(bufnr)

          -- ======
          -- <CR> / <C-t>: open a node's file in a new tab, or switch to the
          -- tab that already has it open. The default <C-t> mapping
          -- (api.node.open.tab) always opens a new tab with no such check,
          -- which is how the same file used to end up open in multiple tabs.
          local function open_or_switch_tab()
            local node = api.tree.get_node_under_cursor()
            if not node or not node.absolute_path then
              vim.notify("No node under cursor", vim.log.levels.WARN)
              return
            end

            -- directory → expand/collapse instead of opening
            if node.type == "directory" then
              api.node.open.edit()
              return
            end

            local file_path = node.absolute_path

            for _, tabid in ipairs(vim.api.nvim_list_tabpages()) do
              for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(tabid)) do
                local buf = vim.api.nvim_win_get_buf(winid)
                if vim.api.nvim_buf_get_name(buf) == file_path then
                  vim.api.nvim_set_current_tabpage(tabid)
                  vim.api.nvim_set_current_win(winid)
                  return
                end
              end
            end

            vim.cmd("tabnew " .. vim.fn.fnameescape(file_path))
            if pcall(require, "tabby") then
              vim.cmd("redrawtabline")
            end
            vim.cmd("wincmd p") -- return focus to NvimTree
          end

          vim.keymap.set("n", "<CR>", open_or_switch_tab, { buffer = bufnr, desc = "Open file in new tab or switch if already open" })
          vim.keymap.set("n", "<C-t>", open_or_switch_tab, { buffer = bufnr, desc = "Open file in new tab or switch if already open" })
          -- ======

          vim.keymap.set("n", "<leader>f", function()
            api.tree.focus()
            api.tree.find_file(vim.fn.expand("%:p"))
          end, { buffer = bufnr, noremap = true, silent = true, desc = "Focus current file in tree" })
        end,
      })

      -- === Automatically open tree on startup ===
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function(data)
          local directory = vim.fn.isdirectory(data.file) == 1
          if directory then
            vim.cmd.cd(data.file)
            api.tree.open()
          else
            vim.defer_fn(function()
              api.tree.open()
            end, 100)
          end
        end,
      })

      -- === Keep tree open on new tabs ===
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
