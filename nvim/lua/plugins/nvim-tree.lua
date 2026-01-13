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
          pcall(vim.keymap.del, "n", "<CR>", { buffer = bufnr })

          -- ✅ Set up all default mappings first
          api.config.mappings.default_on_attach(bufnr)

          -- ======
          -- <CR>: open in new tab or jump if already open
          vim.keymap.set("n", "<CR>", function()
            local node = api.tree.get_node_under_cursor()
            if not node or not node.absolute_path then
              vim.notify("No node under cursor", vim.log.levels.WARN)
              return
            end

            -- 🗂️ If directory → expand/collapse instead of opening
            if node.type == "directory" then
              if node.open then
                api.node.open.edit()  -- collapse
              else
                api.node.open.edit()  -- expand
              end
              return
            end

            local file_path = node.absolute_path
            local found = false

            -- Check if file is visible in any tab
            for _, tabid in ipairs(vim.api.nvim_list_tabpages()) do
              for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(tabid)) do
                local buf = vim.api.nvim_win_get_buf(winid)
                if vim.api.nvim_buf_get_name(buf) == file_path then
                  vim.notify("Switching to existing tab for: " .. file_path, vim.log.levels.INFO)
                  vim.api.nvim_set_current_tabpage(tabid)
                  vim.api.nvim_set_current_win(winid)
                  found = true
                  break
                end
              end
              if found then break end
            end

            if not found then
              vim.notify("Opening new tab for: " .. file_path, vim.log.levels.INFO)
              vim.cmd("tabnew " .. file_path)
              -- Update Tabby immediately if loaded
              if pcall(require, "tabby") then
                vim.cmd("redrawtabline")
              end
              vim.cmd("wincmd p") -- return focus to NvimTree
            end
          end, { buffer = bufnr, desc = "Open file in new tab or switch if already visible" })
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
