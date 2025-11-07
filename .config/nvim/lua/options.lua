local o = vim.o
local opt = vim.opt

-- Set space as leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Relative line numbers in gutter
o.relativenumber = true
o.number = true

-- Number of spaces per tab
o.tabstop = 4

-- Number of spaces to use for indents with >>, << and ==
o.shiftwidth = 4

-- Convert tabs to spaces
o.expandtab = true

-- 24 bit colours
o.termguicolors = true

-- Enable mouse support for all modes
o.mouse = "a"

-- Use local .nvimrc if it exists
opt.exrc = true

-- Disable unsafe commands in local .nvimrc
opt.secure = true

-- Ensure global statusline is always visible
o.laststatus = 2

-- Always show sign column
o.signcolumn = "auto"

-- Undo files
opt.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
o.ignorecase = true
o.infercase = true
o.smartcase = true

-- Usable netrw
vim.g.netrw_bufsettings = "noma nomod rnu nu nobl nowrap ro"

-- Line wrap
o.wrap = false

-- Folding
o.foldenable = true
o.foldlevel = 99
o.foldlevelstart = 99
vim.wo.foldmethod = "expr"
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
function _G.custom_fold_text()
	local line = vim.fn.getline(vim.v.foldstart):gsub("^%s+", "")
	local indent = vim.fn.indent(vim.v.foldstart)
	return string.rep(" ", indent) .. line
end
o.foldtext = "v:lua.custom_fold_text()"

-- Hide fold and and end-of-buffer default chars
o.fillchars = "eob: ,fold: "

o.updatetime = 300

-- Show hidden characters
opt.listchars = {
	tab = "  ",
	trail = "~", -- Trailing spaces
}
opt.list = true

-- Disable cursor line highlight
o.cursorline = false

-- Better scrolling
o.scrolloff = 6
