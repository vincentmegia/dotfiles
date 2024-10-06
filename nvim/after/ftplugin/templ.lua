vim.filetype.add({
	extension = {
		templ = "templ",
	},
})

vim.api.nvim_set_keymap("n", "<leader>cgt", ":w | :!templ generate <CR>", { noremap = true, silent = true })
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
	pattern = { "*.templ" },
	callback = vim.lsp.buf.format,
})
