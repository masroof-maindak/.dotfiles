require("options")
require("keybinds")
require("bootstrap")
require("lsp-config")
require("autocommands")

if vim.env.TERM == "linux" then
    vim.cmd("colorscheme habamax")
end
