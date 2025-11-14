return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,
	branch = "main",
    event = { "BufReadPost", "BufNewFile" },
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").setup()

		local ensure_installed = {
			"bash",
			"c",
			"cpp",
			"css",
			"devicetree",
			"dockerfile",
			"gitignore",
			"go",
			"html",
			"javascript",
			"json",
			"kdl",
			"lua",
			"make",
			"markdown",
			"markdown_inline",
			"python",
			"rust",
			"toml",
			"typescript",
			"typst",
			"vim",
			"vimdoc",
			"yaml",
		}

		require("nvim-treesitter").install(ensure_installed)
	end,
}
