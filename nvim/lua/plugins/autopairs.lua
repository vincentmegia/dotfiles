local M = {}

function M.setup()
  M.spec = {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
      local ok, autopairs = pcall(require, "nvim-autopairs")
      if not ok then
        vim.notify("nvim-autopairs not found", vim.log.levels.WARN)
        return
      end

      autopairs.setup({
        -- Only pair brackets/quotes in Go buffers
        enabled = function(bufnr)
          return vim.bo[bufnr].filetype == "go"
        end,
        check_ts = false,
      })
    end,
  }

  return M
end

return M
