return {
  "ellisonleao/gruvbox.nvim",
  priority = 1000,
  config = function()
    local colorscheme = require('gruvbox')
    colorscheme.setup({
      highlights = {
        Comment = { italic = true },
        Directory = { bold = true },
        ErrorMsg = { italic = true, bold = true }
      },
      styles = {
        types = "bold italic",
        methods = "bold italic underline",
        numbers = "NONE",
        strings = "NONE",
        comments = "italic",
        keywords = "bold,italic",
        constants = "NONE",
        functions = "bold,italic",
        operators = "NONE",
        variables = "NONE",
        parameters = "NONE",
        conditionals = "italic",
        virtual_text = "NONE",
      },
    })
  end,
  init = function ()
    vim.cmd.colorscheme('gruvbox')
  end,
}
