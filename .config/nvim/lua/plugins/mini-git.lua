return {
	{
		{
			"nvim-mini/mini-git",
			version = false,
			cmd = { "Git" },
			main = "mini.git",
			opts = {},
		},
		{
			"nvim-mini/mini.diff",
			version = false,
			event = "BufWinEnter",
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
