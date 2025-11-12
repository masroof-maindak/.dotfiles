local map = vim.keymap.set

-- Basic
map("i", "jk", "<Esc>", { noremap = true, silent = true, desc = "Exit insert mode" })
map("n", "<C-s>", "<CMD>w<CR>", { noremap = true, silent = true, desc = ":w" })
map("n", "<C-q>", "<CMD>qa<CR>", { noremap = true, silent = true, desc = ":qa" })
map("n", "<leader>q", "<CMD>q<CR>", { noremap = true, silent = true, desc = ":q" })
map("n", "<leader>w", "<CMD>w<CR>", { noremap = true, silent = true, desc = ":w" })
-- FIXME: don't work in tmux because I use alt+hjkl for pane navigation;
-- solution: vim-tmux-navigator & use ctrl+hjkl in tmux too
map("n", "<M-j>", "5j", { noremap = true, silent = true, desc = "Big down" })
map("n", "<M-k>", "5k", { noremap = true, silent = true, desc = "Big up" })

-- Plugin menus
map("n", "<leader>kt", "<CMD>Themery<CR>", { noremap = true, desc = "Colour theme picker" })
map("n", "<leader>l", "<CMD>Lazy<CR>", { noremap = true, desc = "Lazy" })
map("n", "<leader>m", "<CMD>Mason<CR>", { noremap = true, desc = "Mason" })

-- Misc
map("v", "<", "<gv", { noremap = true, silent = true })
map("v", ">", ">gv", { noremap = true, silent = true })
map("n", "<Esc>", "<CMD>noh<CR><Esc>", { noremap = true, silent = true, desc = "Remove highlights" })
-- FIXME: doesn't work w/ my Kanata config beause I use double-caps for caps-wor
-- map("t", "<Esc><Esc>", "<C-\\><C-n>", { noremap = true, silent = true, desc = "Exit insert mode in terminal" })

-- Buffer Management
map("n", "<leader>bd", "<CMD>bd<CR>", { noremap = true, desc = "Delete buffer" })
map("n", "<Tab>", "<CMD>bn<CR>", { noremap = true, silent = true })
map("n", "<S-Tab>", "<CMD>bp<CR>", { noremap = true, silent = true })
map("n", "<leader>bc", function()
	MiniBufremove.delete()
end, { noremap = true, desc = "Intelligently close buffer" })

-- Update Neovim's CWD to that of the current file
map("n", "<Leader>cd", function()
	local dir = vim.fn.expand("%:p:h")
	vim.cmd("cd " .. dir)
	print("Working directory: " .. vim.fn.getcwd())
end, { silent = true })

-- Mini.files
local function open_mini_files(arg)
	if not MiniFiles.close() then
		MiniFiles.open(arg)
	end
end

map("n", "-", function()
	open_mini_files(vim.api.nvim_buf_get_name(0))
end, { desc = "Open MiniFiles in current file's directory" })

map("n", "_", function()
	open_mini_files(vim.uv.cwd())
end, { desc = "Open MiniFiles in launch directory" })

-- Mini.pick
map("n", "<leader>pf", "<CMD>Pick files<CR>", { noremap = true, desc = "Select file" })
map("n", "<leader>pb", "<CMD>Pick buffers<CR>", { noremap = true, desc = "Select buffer" })
map("n", "<leader>ph", "<CMD>Pick help<CR>", { noremap = true, desc = "Select buffer" })
map("n", "<leader>gs", "<CMD>Pick grep live<CR>", { noremap = true, desc = "Live grep across files" })

-- Version Control
map("n", "go", "<CMD>lua MiniDiff.toggle_overlay()<CR>", { noremap = true, desc = "Toggle diff overlay" })
map({ "n", "x" }, "<Leader>gc", "<CMD>lua MiniGit.show_at_cursor()<CR>", { desc = "Show Git history at cursor" })
map({ "n", "v" }, "<Leader>gh", "<CMD>lua MiniGit.show_range_history()<CR>", { desc = "Git show range history" })
map({ "n", "v" }, "<Leader>gd", "<CMD>lua MiniGit.show_diff_source()<CR>", { desc = "Git show diff source" })

-- Move to the beginning/end of the line
map("n", "L", "$", { noremap = true, silent = true })
map("n", "H", "^", { noremap = true, silent = true })
map("v", "L", "g_", { noremap = true, silent = true })
map("v", "H", "^", { noremap = true, silent = true })

-- Completion
map("i", "<C-f>", [[pumvisible() ? "\<C-y>" : "\<C-f>"]], { expr = true })
map("i", "<Tab>", [[pumvisible() ? "\<C-n>" : "\<Tab>"]], { expr = true })
map("i", "<S-Tab>", [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true })

-- LSP
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })

map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Open diagnostics float" })
map("n", "[[", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
map("n", "]]", vim.diagnostic.goto_prev, { desc = "Go to prev diagnostic" })

map("i", "<C-h>", vim.lsp.buf.signature_help, { desc = "Show signature help" })

-- Window navigation
map("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
map("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
map("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })
map("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })

-- Window resizing
map("n", "<C-left>", "<C-w><", { noremap = true, silent = true })
map("n", "<C-down>", "<C-w>-", { noremap = true, silent = true })
map("n", "<C-up>", "<C-w>+", { noremap = true, silent = true })
map("n", "<C-right>", "<C-w>>", { noremap = true, silent = true })
