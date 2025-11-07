return {
	-- nvim-autopairs doesn't allow you to 'skip over' an auto-closed
	-- pair with the same character.

	"altermo/ultimate-autopair.nvim",
	event = { "InsertEnter", "CmdlineEnter" },
	branch = "v0.6",
	opts = {
		{ "$", "$", ft = { "typst" }, multiline = false },
		{ "*", "*", ft = { "markdown" }, multiline = false },
		{ "_", "_", ft = { "markdown", "typst" }, multiline = false },
		{ "**", "**", ft = { "markdown" }, multiline = false },
		{ "~~", "~~", ft = { "markdown" }, multiline = false },
		{ '"""', '"""', insta_newline = true, ft = { "python" } },
		config_internal_pairs = {
			{ "[", "]", ft = { "markdown" }, treesitter = false },
		},
	},
}
