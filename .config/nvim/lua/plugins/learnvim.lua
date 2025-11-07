return {
	{
		"m4xshen/hardtime.nvim",
		lazy = false,
		dependencies = { "MunifTanjim/nui.nvim" },
		opts = {},
	},
	{
		"tris203/precognition.nvim",
		event = "VeryLazy",
		opts = {
			showBlankVirtLine = true,
			disabled_fts = {
			    "ministarter",
			},
		},
	},
}
