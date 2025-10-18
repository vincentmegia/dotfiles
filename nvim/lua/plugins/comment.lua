local M = {}

function M.setup()
  M.spec = {
    "numToStr/Comment.nvim",
    event = "BufReadPost",
    config = function()
      local ok, comment = pcall(require, "Comment")
      if not ok then
        vim.notify("Comment.nvim not found", vim.log.levels.WARN)
        return
      end

      comment.setup({
        mappings = {
          basic = true,
          extra = true,
        },
      })

      -- Most terminals map Ctrl+/ as Ctrl-_
      vim.keymap.set("n", "<C-_>", function()
        require("Comment.api").toggle.linewise.current()
      end, { noremap = true, silent = true, desc = "Toggle comment (line)" })

      vim.keymap.set("v", "<C-_>", "<ESC><CMD>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", {
        noremap = true,
        silent = true,
        desc = "Toggle comment (visual)",
      })
    end,
  }

  return M
end

return M
