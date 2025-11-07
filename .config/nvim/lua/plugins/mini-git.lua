return {
	{
		{
			"nvim-mini/mini-git",
			version = false,
			event = "VeryLazy",
			main = "mini.git",
			opts = {},
		},
		{
			"nvim-mini/mini.diff",
			version = false,
			event = "VeryLazy",
			opts = {
				delay = { text_change = 300 },
				view = {
					style = "sign",
					signs = { add = "+", change = "~", delete = "-" },
				},
			},
		},
	},
}
