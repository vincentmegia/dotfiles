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

require("dap-go").setup()
local sw_keymaps = require("stupendousware.keymaps")
sw_keymaps.lsp_keymap_setup()
sw_keymaps.debug_keymap_setup()
