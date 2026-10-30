return {
	{ -- Configure formatters
		"stevearc/conform.nvim",
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "Format buffer",
			},
		},
		opts = {
			formatters_by_ft = {
				asm = { "asmfmt" },
				bash = { "shfmt" },
				["c++"] = { "clang-format" },
				c = { "clang-format" },
				cmake = { "gersemi" },
				css = { "deno_fmt" },
				html = { "deno_fmt" },
				javascript = { "deno_fmt" },
				json = { "deno_fmt" },
				kdl = { "kdlfmt" },
				lua = { "stylua" },
				markdown = { "mdformat" },
				php = { "pretty-php" },
				python = { "ruff_organize_imports", "ruff_format", stop_after_first = false },
				rust = { "rustfmt" },
				scss = { "deno_fmt" },
				sh = { "shfmt" },
				typescript = { "deno_fmt" },
				typst = { "typstyle" },
				yaml = { "deno_fmt" },
			},

			format_on_save = nil,

			formatters = {
				shfmt = {
					prepend_args = { "-i", "2" },
				},

				typstyle = {
					append_args = { "--wrap-text" },
				},

				mdformat = {
					prepend_args = { "--number", "--wrap", "80" },
				},
			},
		},
		after = "mason.nvim",
		init = function()
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		end,
	},
}
