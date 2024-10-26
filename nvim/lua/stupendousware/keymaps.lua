local M = {}

M.lsp_keymap_setup = function()
	local lspbuf = vim.lsp.buf
	local opts = { noremap = true, silent = true }
	local diagnostics = vim.diagnostic
	local keymap = vim.keymap

	-- set base keybindings
	-- set keybindings
	opts.desc = "Show LSP References"
	keymap.set("n", "<leader>lgr", "<cmd>Telescope lsp_references<CR>", opts)

	opts.desc = "Show LSP Document Symbols"
	keymap.set("n", "<leader>lgds", "<cmd>Telescope lsp_document_symbols<CR>", opts)

	opts.desc = "Show LSP Workspace Symbols"
	keymap.set("n", "<leader>lgws", "<cmd>Telescope lsp_workspace_symbols<CR>", opts)

	opts.desc = "Show LSP Definitions"
	keymap.set("n", "<leader>lgd", "<cmd>Telescope lsp_definitions<CR>", opts)

	opts.desc = "Show LSP Implementations"
	keymap.set("n", "<leader>lgi", "<cmd>Telescope lsp_implementations<CR>", opts)

	opts.desc = "Show LSP Type Definitions"
	keymap.set("n", "<leader>lgtd", "<cmd>Telescope lsp_type_definitions<CR>", opts)

	opts.desc = "See Available Code Actions"
	keymap.set({ "n", "v" }, "<leader>ca", lspbuf.code_action)

	opts.desc = "Smart Rename"
	keymap.set("n", "<leader>rn", lspbuf.rename)

	opts.desc = "Show Buffer Diagnostics"
	keymap.set("n", "<leader>bd", "<cmd>Telescope diagnostics<CR>", opts)

	opts.desc = "Show Line Diagnostics"
	keymap.set("n", "<leader>dl", diagnostics.open_float)

	opts.desc = "GoTo Previous Diagnostics"
	keymap.set("n", "[d", diagnostics.goto_prev)

	opts.desc = "GoTo next Diagnostics"
	keymap.set("n", "]d", diagnostics.goto_next)

	opts.desc = "Show Documentation for what is under cursor"
	keymap.set("n", "<leader>K", lspbuf.hover)

	-- GIT
	opts.desc = "Show Git commits"
	keymap.set("n", "<leader>sgc", "<cmd>Telescope git_commits<CR>", opts)

	opts.desc = "Show Git buffer commits"
	keymap.set("n", "<leader>sgbc", "<cmd>Telescope git_bcommits<CR>", opts)

	opts.desc = "Show Git Branches"
	keymap.set("n", "<leader>sgB", "<cmd>Telescope git_branches<CR>", opts)

	opts.desc = "Show Git status"
	keymap.set("n", "<leader>sgs", "<cmd>Telescope git_status<CR>", opts)

	opts.desc = "Show Git Stash"
	keymap.set("n", "<leader>sgS", "<cmd>Telescope git_stash<CR>", opts)

	opts.desc = "Restart LSP"
	keymap.set("n", "<leader>rs", "<cmd>LspRestart<CR>", opts)
end

M.debug_keymap_setup = function()
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

	local dapui = require("dapui")
	keymap.set("n", "<leader>dc", function()
		dap.disconnect()
		dap.close()
		dapui.close()
	end)

	-- debugger ui toggles
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
end

return M
