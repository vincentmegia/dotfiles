-- plugins/notify.lua
local M = {}

function M.setup()
  M.spec = {
    "rcarriga/nvim-notify",
    config = function()
      local ok, notify = pcall(require, "notify")
      if not ok then return end
      vim.notify = notify -- override default handler
      notify.setup({
        stages = "fade",
        timeout = 3000,
        background_colour = "#000000",
        fps = 60,
        icons = {
          ERROR = "",
          WARN = "",
          INFO = "",
          DEBUG = "",
          TRACE = "✎",
        },
      })
    end,
  }
  return M
end

return M
