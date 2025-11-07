return {
	{ -- Downloads
		"mason-org/mason.nvim",
		opts = {
			ui = {
				icons = {
					package_installed = "+",
					package_pending = "»",
					package_uninstalled = "×",
				},
			},
		},
	},
	{ -- Default LSP configs
		"neovim/nvim-lspconfig",
		event = "BufReadPre",
	},
}
