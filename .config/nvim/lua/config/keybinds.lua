local key = vim.keymap.set

-- Exit insert mode w/ 'jk'
key("i", "jk", "<Esc>", { noremap = true, silent = true })

-- Save with 'Ctrl-s'
key("n", "<C-s>", ":w<CR>", { noremap = true, silent = true })

-- Quit all buffers with 'Ctrl-q'
key("n", "<C-q>", ":qa<CR>", { noremap = true, silent = true })

-- Move to the beginning/end of the line
key("n", "L", "$", { noremap = true, silent = true })
key("n", "H", "^", { noremap = true, silent = true }) 
key("v", "L", "g_", { noremap = true, silent = true })
key("v", "H", "^", { noremap = true, silent = true })

-- 'Tab' cycles through completion items
key('i', '<Tab>',   [[pumvisible() ? "\<C-n>" : "\<Tab>"]],   { expr = true })
key('i', '<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true })

-- Window navigation with 'Ctrl-hjkl'
key('n', '<C-h>', '<C-w>h', { noremap = true, silent = true })
key('n', '<C-j>', '<C-w>j', { noremap = true, silent = true })
key('n', '<C-k>', '<C-w>k', { noremap = true, silent = true })
key('n', '<C-l>', '<C-w>l', { noremap = true, silent = true })

-- Window resize with 'Ctrl-arrow'
key('n', '<C-left>',  '<C-w><', { noremap = true, silent = true })
key('n', '<C-down>',  '<C-w>-', { noremap = true, silent = true })
key('n', '<C-up>',    '<C-w>+', { noremap = true, silent = true })
key('n', '<C-right>', '<C-w>>', { noremap = true, silent = true })

-- Cycle to the next buffer with 'Tab'
key('n', '<Tab>', ':bn<CR>', { noremap = true, silent = true })
key('n', '<S-Tab>', ':bp<CR>', { noremap = true, silent = true })

-- Clear search highlights with 'Esc'
key('n', '<Esc>', ':noh<CR><Esc>', { noremap = true, silent = true })
