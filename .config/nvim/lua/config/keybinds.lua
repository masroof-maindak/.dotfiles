-- Exit insert mode w/ 'jk'
vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true })

-- Save with 'Ctrl-s'
vim.keymap.set("n", "<C-s>", ":w<CR>", { noremap = true, silent = true })

-- Quit all buffers with 'Ctrl-q'
vim.keymap.set("n", "<C-q>", ":qa<CR>", { noremap = true, silent = true })

-- Move to the beginning/end of the line
vim.keymap.set("n", "L", "$", { noremap = true, silent = true })
vim.keymap.set("n", "H", "^", { noremap = true, silent = true }) 
vim.keymap.set("v", "L", "g_", { noremap = true, silent = true })
vim.keymap.set("v", "H", "^", { noremap = true, silent = true })

-- 'Tab' cycles through completion items
vim.keymap.set('i', '<Tab>',   [[pumvisible() ? "\<C-n>" : "\<Tab>"]],   { expr = true })
vim.keymap.set('i', '<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true })

-- Window navigation with 'Ctrl-hjkl'
vim.keymap.set('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
vim.keymap.set('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
vim.keymap.set('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })
vim.keymap.set('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })

-- Window resize with 'Ctrl-arrow'
vim.keymap.set('n', '<C-left>',  '<C-w><', { noremap = true, silent = true })
vim.keymap.set('n', '<C-down>',  '<C-w>-', { noremap = true, silent = true })
vim.keymap.set('n', '<C-up>',    '<C-w>+', { noremap = true, silent = true })
vim.keymap.set('n', '<C-right>', '<C-w>>', { noremap = true, silent = true })

-- Cycle to the next buffer with 'Tab'
vim.keymap.set('n', '<Tab>', ':bn<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<S-Tab>', ':bp<CR>', { noremap = true, silent = true })

-- Clear search highlights with 'Esc'
vim.api.nvim_set_keymap('n', '<Esc>', ':noh<CR><Esc>', { noremap = true, silent = true })
