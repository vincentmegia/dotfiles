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

return M
