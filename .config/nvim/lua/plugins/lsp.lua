return {
	{ -- Downloads
		"mason-org/mason.nvim",
		cmd = { "Mason", "MasonInstall", "MasonUninstall" },
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
