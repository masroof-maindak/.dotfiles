local M = {}

local options = {
	dark = "Swamp Dark",
	light = "Swamp Light",
}

local themery

local function apply(mode)
	if mode == "dark" or mode == "light" then
		themery.setThemeByName(options[mode], true)
	end
end

local function start()
	vim.fn.jobstart({ "darkman", "watch" }, {
		on_stdout = function(_, data)
			for _, line in ipairs(data) do
				if line ~= "" then
					apply(vim.trim(line))
				end
			end
		end,
		on_exit = function()
			vim.defer_fn(start, 2000)
		end,
	})
end

local function themeryReady()
	local ok, themes = pcall(themery.getAvailableThemes)
	if not ok or not themes then
		return false
	end
	for _, theme in ipairs(themes) do
		if theme.name == options.dark or theme.name == options.light then
			return true
		end
	end
	return false
end

function M.setup(user_opts)
	if vim.env.TERM == "linux" or vim.fn.executable("darkman") ~= 1 then
		return
	end

	options = vim.tbl_deep_extend("force", options, user_opts or {})
	themery = require("themery")

	if themeryReady() then
		start()
	else
		vim.api.nvim_create_autocmd("VimEnter", { once = true, callback = start })
	end
end

return M
