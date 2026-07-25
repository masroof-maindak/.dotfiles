return {
	"zaldih/themery.nvim",
	cond = function() return vim.env.TERM ~= "linux" end, -- TTY
	lazy = false,
	opts = {
		livePreview = true,
		themes = {
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
			{
				name = "Habamax",
				colorscheme = "habamax",
			},
		},
	},
}
