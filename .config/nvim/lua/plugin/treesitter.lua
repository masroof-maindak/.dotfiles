require('nvim-treesitter.configs').setup({
    ensure_installed = { 'lua', 'vimdoc', 'python', 'cpp', 'c', 'go', 'javascript', 'php', 'markdown', 'json', 'yaml',
        'html', 'css', 'dockerfile' },

    auto_install = true,

    highlight = { enable = true },

    indent = { enable = true },

    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "<A-o>",
            node_incremental = "<A-o>",
            node_decremental = "<A-i>"
        }
    }
})
