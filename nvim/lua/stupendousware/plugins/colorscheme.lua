return {
  "folke/tokyonight.nvim",
  --"rebelot/kanagawa.nvim",
  lazy = false,
  -- "ellisonleao/gruvbox.nvim",
  --dir = "~/repository/gruvbox-stupendous.nvim",
  priority = 1000,
  --config = true,
  init = function()
    vim.opt.background = "dark"
    --vim.cmd("colorscheme gruvbox")
    vim.cmd("colorscheme tokyonight-storm")
    --vim.cmd("colorscheme kanagawa-wave")
  end,
}
