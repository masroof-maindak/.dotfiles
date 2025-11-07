return {
	"zaldih/themery.nvim",
	lazy = false,
	opts = {
		livePreview = true,
		themes = {
			{
				name = "Melange Dark",
				colorscheme = "melange",
				before = [[vim.opt.background = "dark"]],
			},
			{
				name = "Melange Light",
				colorscheme = "melange",
				before = [[vim.opt.background = "light"]],
			},
			{
				name = "Swamp Dark",
				colorscheme = "swamp",
				before = [[vim.opt.background = "dark"]],
			},
			{
				name = "Swamp Light",
				colorscheme = "swamp",
				before = [[vim.opt.background = "light"]],
			},
			{
				name = "Oxocarbon Dark",
				colorscheme = "oxocarbon",
				before = [[vim.opt.background = "dark"]],
			},
			{
				name = "Oxocarbon Light",
				colorscheme = "oxocarbon",
				before = [[vim.opt.background = "light"]],
			},
		},
	},
}
