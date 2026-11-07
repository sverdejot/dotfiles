vim.lsp.config("*", {
	capabilities = require("blink.cmp").get_lsp_capabilities(),
})

vim.lsp.config("cucumber_language_server", {
	filetypes = { "cucumber", "feature" },
})

vim.lsp.enable({
	"gopls", "templ", "csharp_ls", "marksman", "pyright", "ts_ls", "buf_ls", "gleam",
	"cucumber_language_server",
})

vim.diagnostic.config({
	virtual_text = { current_line = true },
	severity_sort = true,
	float = { border = "rounded" },
})

vim.keymap.set("n", "<leader>x", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local opts = { buffer = ev.buf }
		local fzf = require("fzf-lua")
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "gd", fzf.lsp_definitions, opts)
		vim.keymap.set("n", "gi", fzf.lsp_implementations, opts)
		vim.keymap.set("n", "gr", fzf.lsp_references, opts)
		vim.keymap.set("n", "K", function() vim.lsp.buf.hover({ border = "rounded" }) end, opts)
		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set("n", "<space>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, opts)
		vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
		vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "<space>ds", fzf.lsp_document_symbols, opts)
		vim.keymap.set("n", "<space>ws", fzf.lsp_live_workspace_symbols, opts)
		vim.keymap.set({ "n", "v" }, "<space>f", function()
			require("conform").format({ async = true, lsp_format = "fallback" })
		end, opts)

		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client and client:supports_method("textDocument/inlayHint") then
			vim.keymap.set("n", "<space>ih", function()
				vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = ev.buf }), { bufnr = ev.buf })
			end, opts)
		end
	end,
})
