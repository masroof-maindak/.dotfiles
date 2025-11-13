return {
	"aserowy/tmux.nvim",
	event = "VeryLazy",
	opts = {
		copy_sync = {
			enable = false,
			sync_clipboard = true,
			sync_registers = true,
		},
	},
}

-- Auto-sets the following keybinds:

-- Window navigation
-- vim.keymap.set("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
-- vim.keymap.set("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
-- vim.keymap.set("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })
-- vim.keymap.set("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })

-- Window resizing
-- vim.keymap.set("n", "<M-h>", "<C-w><", { noremap = true, silent = true })
-- vim.keymap.set("n", "<M-j>", "<C-w>-", { noremap = true, silent = true })
-- vim.keymap.set("n", "<M-k>", "<C-w>+", { noremap = true, silent = true })
-- vim.keymap.set("n", "<M-l>", "<C-w>>", { noremap = true, silent = true })

-- Pane swapping
-- vim.keymap.set("n", "<M-C-h>", "<C-w>H", { noremap = true, silent = true })
-- vim.keymap.set("n", "<M-C-j>", "<C-w>J", { noremap = true, silent = true })
-- vim.keymap.set("n", "<M-C-k>", "<C-w>K", { noremap = true, silent = true })
-- vim.keymap.set("n", "<M-C-l>", "<C-w>L", { noremap = true, silent = true })
