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
          find_files = { theme = "dropdown", hidden = true },
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
