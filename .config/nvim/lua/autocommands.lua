-- LSP
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("user_lsp_attach", { clear = true }),
	callback = function(event)
		local client = vim.lsp.get_client_by_id(event.data.client_id)

		-- Inlay hints
		if client ~= nil and client.server_capabilities.inlayHintProvider then
			vim.lsp.inlay_hint.enable(true)
		end

		-- Disable Ruff's hover in favor of Pyright's
		if client.name == "ruff" then
			client.server_capabilities.hoverProvider = false
		end

		vim.bo[event.buf].omnifunc = "v:lua.MiniCompletion.completefunc_lsp"
	end,
})

-- Disable Linenumbers in Terminals
vim.api.nvim_create_autocmd("TermEnter", {
	callback = function()
		vim.o.number = false
		vim.o.relativenumber = false
	end,
})

-- Enable treesitter if we have a parser for the filetype
vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		local bufnr = args.buf
		local ft = vim.bo[bufnr].filetype
		if ft == "" then
			return
		end

		if vim.treesitter.language.add(ft) then
			vim.treesitter.start(bufnr, ft)
		end
	end,
})
