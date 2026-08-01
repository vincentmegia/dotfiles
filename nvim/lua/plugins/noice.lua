local M = {}

function M.setup()
  M.spec = {
    "folke/noice.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    version = "*", -- make sure latest is pulled
    opts = {
      cmdline = {
        view = "cmdline_popup",
        float = { size = { width = 80, height = 15 } },
      },
      messages = { view = "split" },
      lsp = {
        progress = {
          enabled = true,
        },
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
      },
    }
  }
  return M
end

return M
