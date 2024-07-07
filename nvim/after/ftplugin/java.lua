local dap, dapui = require("dap"), require("dapui")
dapui.setup()

-- setup listernes
dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end

local keymap = vim.keymap
keymap.set("n", "<leader>db", "<cmd>lua require('dap').toggle_breakpoint()<cr>")
keymap.set("n", "<F2>", "<cmd>lua require('dap').terminate()<cr>")
keymap.set("n", "<F5>", "<cmd>lua require('dap').continue()<cr>")
keymap.set("n", "<F7>", "<cmd>lua require('dap').step_into()<cr>")
keymap.set("n", "<F8>", "<cmd>lua require('dap').step_over()<cr>")
keymap.set("n", "<S-F8>", "<cmd>lua require('dap').step_out()<cr>")
keymap.set("n", "<leader>dro", "<cmd>lua require('dap').repl.open()<cr>")
keymap.set("n", "<leader>dd", "<cmd>lua require('dap').disconnect()<cr>")

-- debugger ui toggles
keymap.set("n", "<leader>dwo", "<cmd>lua require('dapui').open()<cr>")
keymap.set("n", "<leader>dwt", "<cmd>lua require('dapui').terminate()<cr>")
keymap.set("n", "<leader>dwc", "<cmd>lua require('dapui').close()<cr>")
keymap.set("n", "<leader>dwt", "<cmd>lua require('dapui').toggle()<cr>")
keymap.set("n", "<leader>dwe", "<cmd>lua require('dapui').eval()<cr>")



keymap.set('n', '<Leader>B', function() require('dap').set_breakpoint() end)
keymap.set('n', '<Leader>lp',
  function() require('dap').set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end)
keymap.set('n', '<Leader>dr', function() require('dap').repl.open() end)
keymap.set('n', '<Leader>dl', function() require('dap').run_last() end)
keymap.set({ 'n', 'v' }, '<Leader>dh', function()
  require('dap.ui.widgets').hover()
end)
keymap.set({ 'n', 'v' }, '<Leader>dp', function()
  require('dap.ui.widgets').preview()
end)
keymap.set('n', '<Leader>df', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.frames)
end)
keymap.set('n', '<Leader>ds', function()
  local widgets = require('dap.ui.widgets')
  widgets.centered_float(widgets.scopes)
end)

-- custom icons
vim.fn.sign_define('DapBreakpoint', { text = '🛑', texthl = '', linehl = '', numhl = '' })
