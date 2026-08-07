local M = {}

function M.setup()
  M.spec = {
    "numToStr/Comment.nvim",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
    event = "BufReadPost",
    config = function()
      local ok, comment = pcall(require, "Comment")
      if not ok then
        vim.notify("Comment.nvim not found", vim.log.levels.WARN)
        return
      end

      require("ts_context_commentstring").setup({ enable_autocmd = false })

      comment.setup({
        pre_hook = function(ctx)
          local U = require("ts_context_commentstring.utils")
          if U.is_cursor_inside_comment() then
            return { comment = "" }
          end
          local result = require("ts_context_commentstring.integrations.comment_nvim")
            .create_pre_hook()(ctx)
          if result then
            return result
          end
          -- fallback: use buffer's commentstring
          if vim.bo.commentstring then
            return { comment = vim.bo.commentstring }
          end
          return { comment = "" }
        end,
        opleader = {
          line = "<leader>gb",
          block = "<leader>gc",
        },
        toggler = {
          line = "gcc",
          block = "gbc",
        },
        extra = {
          below = "gco",
          above = "gcO",
          eol = "gcA",
        },
      })

      vim.keymap.set("n", "<leader>gb", function()
        require("Comment.api").toggle.linewise.current()
      end, { noremap = true, silent = true, desc = "Toggle comment (line)" })

      vim.keymap.set("v", "<leader>gb", "<ESC><CMD>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", {
        noremap = true,
        silent = true,
        desc = "Toggle comment (visual)",
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
