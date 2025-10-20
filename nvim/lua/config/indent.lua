-- Set 3 spaces for JS/TS files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  callback = function()
    vim.bo.shiftwidth = 3
    vim.bo.tabstop = 3
    vim.bo.softtabstop = 3
    vim.bo.expandtab = true  -- Use spaces instead of tabs
  end,
})
