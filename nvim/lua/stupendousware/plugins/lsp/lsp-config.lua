return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
	},
	config = function()
		-- define global icons
		local iconsDap = require("stupendousware.icons").dap
		local iconsDiagnostics = require("stupendousware.icons").diagnostics
		local fn = vim.fn
		fn.sign_define("DapBreakpoint", { text = iconsDap.Breakpoint, texthl = "", linehl = "", numhl = "" })
		fn.sign_define("DiagnosticSignError", { text = iconsDiagnostics.Error, texthl = "DiagnosticSignError" })
		fn.sign_define("DiagnosticSignWarn", { text = iconsDiagnostics.Warn, texthl = "DiagnosticSignWarn" })
		fn.sign_define("DiagnosticSignInfo", { text = iconsDiagnostics.Info, texthl = "DiagnosticSignInfo" })
		fn.sign_define("DiagnosticSignHint", { text = iconsDiagnostics.Hint, texthl = "DiagnosticSignHint" })
		vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })
		-- setup diagnostics icons
		vim.diagnostic.config({
			severity_sort = true,
			virtual_text = false,
			float = { border = "single" },
			jump = {
				_highest = true,
			},
			-- commented, not working
			--[[ signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = icons.Error,
          [vim.diagnostic.severity.WARN] = icons.Warn,
          [vim.diagnostic.severity.INFO] = icons.Info,
          [vim.diagnostic.severity.HINT] = icons.Hint,
        },
      }, ]]
		})

		-- setup neodev before lspconfig
		-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
		require("neodev").setup({
			-- add any options here, or leave empty to use the default settings
			library = { plugins = { "nvim-dap-ui" }, types = true },
		})

		-- import lspconfig plugin
		local lsp_config = require("lspconfig")
		local keymap = vim.keymap

		local on_attach = function(_, bufnr)
			require("stupendousware.keymaps").lsp_keymap_setup()
		end

		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- configure html server
		lsp_config["html"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { "html", "htm" },
		})

		lsp_config["htmx"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { "html", "htmx" },
		})

		lsp_config["ts_ls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { "typescript", "typescriptreact", "typescript.tsx" },
			cmd = { "typescript-language-server", "--stdio" },
		})

		lsp_config["cssls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
		})

		lsp_config["gopls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { "go", "gomod", "gowork", "gotempl", "templ" },
		})

		lsp_config["templ"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { "templ", "html", "htm" },
		})

		lsp_config["yamlls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { "yaml" },
		})

		lsp_config["tailwindcss"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			filetypes = { "templ", "astro", "javascript", "typescript", "react" },
			settings = {
				tailwindCSS = {
					includeLanguages = {
						templ = "html",
					},
				},
			},
		})

		lsp_config["lua_ls"].setup({
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				Lua = {
					-- make the language server recognize vim global
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						-- make the language server aware of runtime files
						library = {
							[vim.fn.expand("$VIMRUNTIME/lua")] = true,
							[vim.fn.stdpath("config") .. "/lua"] = true,
						},
					},
				},
			},
		})
	end,
	--cmd = { "Mason" }
}
