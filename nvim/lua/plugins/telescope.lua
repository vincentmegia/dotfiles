local M = {}

function M.setup()
  -- Plugin specification table for Lazy.nvim
  M.spec = {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",                   -- required
      "nvim-tree/nvim-web-devicons",             -- icons support
      "nvim-telescope/telescope-fzf-native.nvim" -- optional: fuzzy search
    },
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>",            desc = "Find Files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>",             desc = "Live Grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>",               desc = "List Buffers" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>",             desc = "Help Tags" },
      { "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>",  desc = "Document Symbols" },
      { "<leader>fw", "<cmd>Telescope lsp_workspace_symbols<cr>", desc = "Workspace Symbols" },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")

      -- ======
      -- Selecting a file that's already open in another tab should focus
      -- that tab instead of loading a second copy into the current window
      -- (matches the dedup behavior nvim-tree's <CR>/<C-t> already use).
      local function open_or_switch_tab(prompt_bufnr)
        local entry = action_state.get_selected_entry()
        if not entry then
          return
        end
        local file_path = vim.fn.fnamemodify(entry.path or entry[1], ":p")
        actions.close(prompt_bufnr)

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
      end
      -- ======

      telescope.setup({
        defaults = {
          prompt_prefix = "🔍 ",
          selection_caret = " ",
          entry_prefix = "  ",
          path_display = { "smart" },
          sorting_strategy = "ascending",
          layout_strategy = "horizontal",
          layout_config = {
            horizontal      = { preview_width = 0.6 },
            --vertical   = { preview_height = 0.5 },
            vertical        = { preview_height = 1 },
            width           = 0.9,
            height          = 0.8,
            prompt_position = "top",
          },
          file_ignore_patterns = { "node_modules", ".git/" },
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<C-c>"] = actions.close,
            },
            n = { ["q"] = actions.close },
          },
        },
        pickers = {
          find_files = {
            theme = "dropdown",
            hidden = true,
            attach_mappings = function(prompt_bufnr, map)
              map("i", "<CR>", open_or_switch_tab)
              map("n", "<CR>", open_or_switch_tab)
              return true
            end,
          },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      })

      -- Load FZF extension safely
      pcall(function() telescope.load_extension("fzf") end)
    end,
  }

  -- Optional: FZF native extension
  M.fzf_native = { "nvim-telescope/telescope-fzf-native.nvim", build = "make" }
end

return M
