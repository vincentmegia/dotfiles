return {
  'nvim-treesitter/nvim-treesitter',
  build = ':TSUpdate',
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "c",
        "lua",
        "vim",
        "vimdoc",
        "query",
        "elixir",
        "javascript",
        "typescript",
        "tsx",
        "html",
        "go",
        "java",
        "templ"
      },
      sync_install = false,
      highlight = { enable = true },
      indent = { enable = true },
      autotag = {
        enable = true,
      },
    })
  end,
}
