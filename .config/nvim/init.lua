require 'config.options'
require 'config.keybinds'
require 'config.lazy-bootstrap'
require 'config.coloropts'

-- vim.keymap.set("n", "-", function() MiniFiles.open(vim.api.nvim_buf_get_name(0)) end)

-- vim.keymap.set("n", "<leader>f", pick.builtin.files, { noremap = true })
-- vim.keymap.set("n", "<leader>b", pick.builtin.buffers, { noremap = true })
-- vim.keymap.set("n", "<leader>/", pick.builtin.grep, { noremap = true })

-- local bufremove = require('mini.bufremove')
-- bufremove.setup()

-- -- bc 'buffer close' variant of :bd deletes the buffer without closing the window
-- vim.api.nvim_create_user_command('BC', function() bufremove.delete(0, true) end, {})
-- vim.cmd('cnoreabbrev bc BC')

-- vim.api.nvim_create_autocmd('LspAttach', {
--   group = vim.api.nvim_create_augroup('UserLspConfig', {}),
--   callback = function(ev)
--     -- Buffer local mappings.
--     -- See `:help vim.lsp.*` for documentation on any of the below functions
--     local opts = { buffer = ev.buf }
--     vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
--     vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
--     vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
--     vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
--     vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
--     vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
--     vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
--     vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
--     vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
--   end,
-- })
