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

local keymap = vim.keymap
local lsp = vim.lsp
local lspbuf = vim.lsp.buf

keymap.set("n", "<leader>ca", lsp.buf.code_action)
keymap.set("n", "<leader>rn", lspbuf.rename)
keymap.set("n", "gD", lsp.buf.declaration)
keymap.set("n", "gd", lsp.buf.definition)
keymap.set("n", "K", lsp.buf.hover)
keymap.set("n", "gi", lsp.buf.implementation)

local dap = require("dap")
keymap.set("n", "<leader>db", dap.toggle_breakpoint)
keymap.set("n", "<leader>dB", dap.set_breakpoint)
keymap.set("n", "<F2>", function()
	dap.terminate()
	dap.close()
end)
keymap.set("n", "<F5>", dap.continue)
keymap.set("n", "<F7>", dap.step_into)
keymap.set("n", "<F8>", dap.step_over)
keymap.set("n", "<F9>", dap.step_out)
keymap.set("n", "<leader>dro", dap.repl.open)
keymap.set("n", "<leader>dc", function()
	dap.disconnect()
	dap.close()
	dapui.close()
end)

-- debugger ui toggles
local dapui = require("dapui")
keymap.set("n", "<leader>dwo", dapui.open)
keymap.set("n", "<leader>dwc", dapui.close)
keymap.set("n", "<leader>dwt", dapui.toggle)
keymap.set("n", "<leader>dwe", dapui.eval)
keymap.set("n", "<leader>B", function()
	require("dap").set_breakpoint()
end)
keymap.set("n", "<leader>lp", function()
	require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
end)
keymap.set("n", "<leader>dro", function()
	require("dap").repl.open()
end)
keymap.set("n", "<leader>drc", function()
	require("dap").repl.close()
end)
keymap.set("n", "<leader>dl", function()
	require("dap").run_last()
end)

local jdtls = require("jdtls")
keymap.set("n", "<leader><F5>", jdtls.test_class)
keymap.set("n", "<leader><F6>", jdtls.test_nearest_method)
keymap.set("n", "<leader><F7>", jdtls.pick_test)

-- ui widgest
local widgets = require("dap.ui.widgets")
keymap.set({ "n", "v" }, "<Leader>dh", function()
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
