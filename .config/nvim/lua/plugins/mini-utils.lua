return {
	{
		"nvim-mini/mini.files",
		version = false,
		keys = {
			{
				"-",
				function()
					local MiniFiles = require("mini.files")
					if not MiniFiles.close() then
						MiniFiles.open(vim.api.nvim_buf_get_name(0))
					end
				end,
				desc = "Open MiniFiles in current file's directory",
			},
			{
				"_",
				function()
					local MiniFiles = require("mini.files")
					if not MiniFiles.close() then
						MiniFiles.open(vim.uv.cwd())
					end
				end,
				desc = "Open MiniFiles in launch directory",
			},
		},
		opts = {
			content = { prefix = function() end },
		}, -- remove icons
	},
	{
		"nvim-mini/mini.pick",
		version = false,
		cmd = { "Pick" },
		config = function()
			local pick = require("mini.pick")
			pick.setup({
				source = {
					show = pick.default_show,
				}, -- remove icons
			})
		end,
	},
	{ -- LSP Completion
		"nvim-mini/mini.completion",
		version = false,
		event = { "InsertEnter", "LspAttach" },
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
	{
		"nvim-mini/mini.bufremove",
		keys = {
			{
				"<leader>bc",
				function()
					require("mini.bufremove").delete()
				end,
				noremap = true,
				desc = "Intelligently close buffer",
			},
		},
		version = false,
		opts = {},
	},
}
