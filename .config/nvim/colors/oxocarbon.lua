local palette

if vim.o.background == "light" then
	palette = {
		base00 = "#f2f4f8",
		base01 = "#dde1e6",
		base02 = "#525252",
		base03 = "#161616",
		base04 = "#262626",
		base05 = "#393939",
		base06 = "#525252",
		base07 = "#08bdba",
		base08 = "#ff7eb6",
		base09 = "#ee5396",
		base0A = "#FF6F00",
		base0B = "#0f62fe",
		base0C = "#673AB7",
		base0D = "#42be65",
		base0E = "#be95ff",
		base0F = "#37474F",
	}
end

if vim.o.background == "dark" then
	palette = {
		base00 = "#161616",
		base01 = "#262626",
		base02 = "#393939",
		base03 = "#525252",
		base04 = "#dde1e6",
		base05 = "#f2f4f8",
		base06 = "#ffffff",
		base07 = "#08bdba",
		base08 = "#3ddbd9",
		base09 = "#78a9ff",
		base0A = "#ee5396",
		base0B = "#33b1ff",
		base0C = "#ff7eb6",
		base0D = "#42be65",
		base0E = "#be95ff",
		base0F = "#82cfff",
	}
end

if palette then
	require("mini.base16").setup({ palette = palette })
	vim.g.colors_name = "base16-swamp"
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
