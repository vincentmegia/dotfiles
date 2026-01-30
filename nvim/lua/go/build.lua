
local M = {}

local term_buf = nil
local term_win = nil

function M.go_build()
  vim.cmd("w")

  -- If terminal buffer is gone, recreate it
  if not term_buf or not vim.api.nvim_buf_is_valid(term_buf) then
    vim.cmd("botright split")
    vim.cmd("resize 15")
    vim.cmd("terminal")

    term_buf = vim.api.nvim_get_current_buf()
    term_win = vim.api.nvim_get_current_win()
  else
    -- Show existing terminal
    if not term_win or not vim.api.nvim_win_is_valid(term_win) then
      vim.cmd("botright split")
      vim.cmd("resize 15")
      vim.api.nvim_set_current_buf(term_buf)
      term_win = vim.api.nvim_get_current_win()
    else
      vim.api.nvim_set_current_win(term_win)
    end
  end

  -- Send command to terminal
  local job_id = vim.b.terminal_job_id
  if job_id then
    --vim.fn.chansend(job_id, "\003") -- Ctrl+C
    vim.fn.chansend(job_id, "clear\n")
    local file = vim.fn.expand("%")
    vim.fn.chansend(job_id, "go build cmd/api/main.go \n")
  else
    vim.notify("Go terminal not ready", vim.log.levels.ERROR)
  end
end

return M
