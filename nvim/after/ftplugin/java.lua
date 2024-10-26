local dap, dapui = require("dap"), require("dapui")
dapui.setup()

-- setup listeners
dap.listeners.before.attach.dapui_config = function()
	dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
	dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	--[[ 	dapui.close() ]]
end
dap.listeners.before.event_exited.dapui_config = function()
	--[[ 	dapui.close() ]]
end

local jdtls = require("jdtls")
local keymap = vim.keymap
keymap.set("n", "<leader><F5>", jdtls.test_class)
keymap.set("n", "<leader><F6>", jdtls.test_nearest_method)
keymap.set("n", "<leader><F7>", jdtls.pick_test)
keymap.set("n", "<leader>jrs", "<cmd>JdtWipeDataAndRestart<CR>")

-- ui widgest
local widgets = require("dap.ui.widgets")
keymap.set({ "n", "v" }, "<leader>dh", function()
	widgets.hover()
end)
keymap.set({ "n", "v" }, "<Leader>dp", function()
	require("dap.ui.widgets").preview()
end)
keymap.set("n", "<leader>df", function()
	widgets.centered_float(widgets.frames)
end)
keymap.set("n", "<leader>ds", function()
	widgets.centered_float(widgets.scopes)
end)

local sw_keymaps = require("stupendousware.keymaps")
sw_keymaps.lsp_keymap_setup()
sw_keymaps.debug_keymap_setup()
