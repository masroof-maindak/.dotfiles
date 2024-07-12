vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.o.clipboard = 'unnamedplus'     -- Use system clipboard
vim.o.relativenumber = true         -- Relative line numbers in gutter
vim.o.tabstop = 4                   -- Number of spaces per tab
vim.o.shiftwidth = 4                -- Number of spaces to use for indents with >>, << and ==
vim.o.updatetime = 300
vim.o.termguicolors = true          -- 24 bit colours
vim.o.mouse = 'a'                   -- Enable mouse support for all modes
vim.opt.exrc = true                 -- Use local .nvimrc if it exists
vim.opt.secure = true               -- Disable unsafe commands in local .nvimrc
vim.o.cursorline = true             -- Highlight current line
vim.o.fillchars = 'eob: '           -- Hide ~ at end of buffers
vim.o.laststatus = 3                -- Ensure global statusline is always visible 
vim.o.signcolumn = 'yes'			-- Always show sign column

vim.o.wrap = false
