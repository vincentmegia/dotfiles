local M = {}

function M.setup()
  M.spec = {
    "supermaven-inc/supermaven-nvim",
    config = function()
      local ok, supermaven = pcall(require, "supermaven-nvim")
      if not ok then
        vim.notify("supermaven-nvim not found", vim.log.levels.WARN)
        return
      end

      supermaven.setup({
        keymaps = {
          accept_suggestion = "<C-a>",
          clear_suggestion  = "<C-]>",
          accept_word       = "<C-l>",
        },
        ignore_filetypes = { "cpp" },
        color = {
          suggestion_color = "#ffffff",
          cterm = 244,
        },
        log_level = "info",
        disable_inline_completion = false,
      })
    end,
  }

  return M
end

return M

