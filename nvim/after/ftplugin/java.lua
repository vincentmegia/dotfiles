local dap, dapui = require("dap"), require("dapui")
dapui.setup()
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
keymap.set("n", "<leader>dc", "<cmd>lua require('dap').continue()<cr>")
keymap.set("n", "<leader>dsi", "<cmd>lua require('dap').step_into()<cr>")
keymap.set("n", "<leader>dso", "<cmd>lua require('dap').step_over()<cr>")
keymap.set("n", "<leader>dro", "<cmd>lua require('dap').repl.open()<cr>")
keymap.set("n", "<leader>dd", "<cmd>lua require('dap').disconnect()<cr>")

-- debugger ui toggles
keymap.set("n", "<leader>dwo", "<cmd>lua require('dapui').open()<cr>")
keymap.set("n", "<leader>dwc", "<cmd>lua require('dapui').close()<cr>")
keymap.set("n", "<leader>dwt", "<cmd>lua require('dapui').toggle()<cr>")
keymap.set("n", "<leader>dwe", "<cmd>lua require('dapui').eval()<cr>")
