local servers = {
	"basedpyright",
	"bashls",
	"clangd",
	"gopls",
	"lua_ls",
	"neocmakelsp",
	"ruff",
	"rust_analyzer",
	"tinymist",
	"vtsls",
}

local on_attach = function(client, bufnr)
	vim.api.nvim_exec_autocmds("LspAttach", {
		buffer = bufnr,
		data = { client_id = client.id },
	})
end

-- Additional configurations for each client other than the defaults

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
	filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "hpp" }, -- Remove proto from default
})

vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			telemetry = { enable = false },
			diagnostics = { globals = { "vim", "MiniFiles", "MiniStatusline", "MiniBufremove" } },
		},
	},
})

vim.lsp.config("basedpyright", {
	settings = {
		basedpyright = {
			disableOrganizeImports = true,
			analysis = {
				typeCheckingMode = "basic",
				useLibraryCodeForTypes = false,
				diagnosticMode = "openFilesOnly",
			},
		},
	},
})

for _, server in ipairs(servers) do
	vim.lsp.config(server, { on_attach = on_attach })
	vim.lsp.enable(server)
end
