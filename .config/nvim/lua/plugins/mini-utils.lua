return {
	{
		"nvim-mini/mini.files",
		version = false,
		opts = {
			content = { prefix = function() end },
		}, -- remove icons
		event = "VeryLazy",
	},
	{
		"nvim-mini/mini.pick",
		version = false,
		config = function()
			local pick = require("mini.pick")
			pick.setup({
				source = {
					show = pick.default_show,
				}, -- remove icons
			})
		end,
		event = "VeryLazy",
	},
	{ -- LSP Completion
		"nvim-mini/mini.completion",
		version = false,
		opts = {
			lsp_completion = {
				source_func = "omnifunc",
				auto_setup = false,
			},
			mappings = {
				scroll_down = "<C-v>",
				scroll_up = "<C-b>",
			},
		},
	},
	{ "nvim-mini/mini.bufremove", version = false, opts = {} },
}
