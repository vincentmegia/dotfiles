local M = {}

function M.setup()
  M.spec = {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    config = true,
  }
  return M
end

return M
