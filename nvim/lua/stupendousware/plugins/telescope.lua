return {
  'nvim-telescope/telescope.nvim',
  branches = '0.1.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzy-native.nvim', build = 'make' },
    'nvim-tree/nvim-web-devicons',
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")

    telescope.setup({
      defaults = {
        path_display = { "truncate " },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next,     -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
      },
    })
    telescope.load_extension('fzy_native')
    local keymap = vim.keymap
    -- telescope bindings
    keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>',
      { desc = 'Fuzzy find files in current working directory' })
    keymap.set('n', '<leader>fr', '<cmd>Telescope oldfiles<cr>', { desc = 'Fuzzy find recent files' })
    keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { desc = 'Find string in current working directly' })
    keymap.set('n', '<leader>fgs', '<cmd>Telescope grep_string<cr>',
      { desc = 'Find string under cursor in current working directly' })
    keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { desc = 'Find string in buffers' })
  end
}
