local servers = {
	"bashls",
	"clangd",
	"gopls",
	"lua_ls",
	"neocmakelsp",
	"ruff",
	"rust_analyzer",
	"tinymist",
	"ty",
	"vtsls",
}

-- Additional configurations for each client other than the defaults (provided
-- by nvim-lspconfig)

vim.lsp.config("clangd", {
	cmd = {
		"clangd",
		"--background-index",
		"--clang-tidy",
		"--header-insertion=iwyu",
		"--completion-style=detailed",
		"--function-arg-placeholders",
		"--fallback-style=llvm",
	},
	init_options = {
		usePlaceholders = true,
		completeUnimported = true,
		clangdFileStatus = true,
	},
})

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			telemetry = { enable = false },
			diagnostics = { globals = { "vim", "MiniFiles", "MiniStatusline", "MiniBufremove" } },
		},
	},
})

for _, server in ipairs(servers) do
	vim.lsp.enable(server)
end
