local palette

if vim.o.background == "light" then
	palette = {
		base00 = "#F1E3D1", -- BG
		base01 = "#DDCEBC", -- BG2
		base02 = "#C9B9A7", -- BG3
		base03 = "#B5A492", -- Comments
		base04 = "#A0907D",
		base05 = "#64513E", -- FG
		base06 = "#786653",
		base07 = "#8C7B68",
		base08 = "#D09700", -- Variables
		base09 = "#64513E", -- numbers
		base0A = "#993333", -- Classes
		base0B = "#908D6A", -- Strings
		base0C = "#d09700", -- Support
		base0D = "#BF7979", -- Functions
		base0E = "#9E5581", -- Keywords
		base0F = "#75858C", -- Parentheses
	}
end

if vim.o.background == "dark" then
	palette = {
		base00 = "#242015",
		base01 = "#3A3124",
		base02 = "#4D3F32",
		base03 = "#5F4E41",
		base04 = "#B8A58C",
		base05 = "#D2C3A4",
		base06 = "#EBE0BB",
		base07 = "#F1E9D0",
		base08 = "#DB930D",
		base09 = "#EBE0BB",
		base0A = "#A82D56",
		base0B = "#7A7653",
		base0C = "#DB930D",
		base0D = "#C1666B",
		base0E = "#91506C",
		base0F = "#61A0A8",
	}
end

if palette then
	require("mini.base16").setup({ palette = palette })
	vim.g.colors_name = "base16-swamp"
	vim.cmd([[ highlight WinSeparator guibg=None ]])
end

local function hi(group, opts)
	vim.api.nvim_set_hl(0, group, opts)
end

hi("LineNr", { fg = palette.base05, bg = palette.base00, attr = nil, sp = nil })
hi("LineNrAbove", { fg = palette.base02, bg = palette.base00, attr = nil, sp = nil })
hi("LineNrBelow", { fg = palette.base02, bg = palette.base00, attr = nil, sp = nil })

hi("MiniDiffSignAdd", { fg = palette.base0B, bg = palette.base00, attr = nil, sp = nil })
hi("MiniDiffSignChange", { fg = palette.base0E, bg = palette.base00, attr = nil, sp = nil })
hi("MiniDiffSignDelete", { fg = palette.base08, bg = palette.base00, attr = nil, sp = nil })

hi("SignColumn", { fg = palette.base03, bg = palette.base00, attr = nil, sp = nil })
hi("CursorLineNr", { fg = palette.base05, bg = nil, attr = nil, sp = nil })

hi("DiagnosticFloatingError", { fg = palette.base08, bg = palette.base00, attr = nil, sp = nil })
hi("DiagnosticFloatingHint", { fg = palette.base0D, bg = palette.base00, attr = nil, sp = nil })
hi("DiagnosticFloatingInfo", { fg = palette.base0C, bg = palette.base00, attr = nil, sp = nil })
hi("DiagnosticFloatingOk", { fg = palette.base0B, bg = palette.base00, attr = nil, sp = nil })
hi("DiagnosticFloatingWarn", { fg = palette.base0E, bg = palette.base00, attr = nil, sp = nil })

hi("MiniStatuslineDevinfo", { fg = palette.base05, bg = palette.base02, attr = nil, sp = nil })
hi("MiniStatuslineFilename", { fg = palette.base06, bg = palette.base01, attr = nil, sp = nil })
