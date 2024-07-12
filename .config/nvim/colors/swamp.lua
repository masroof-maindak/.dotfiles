local palette

if vim.o.background == "light" then
  palette = {
    base00 = "#f1e3d1", -- BG
    base01 = "#DDCEBC", -- BG2
    base02 = "#C9B9A7", -- BG3
    base03 = "#B5A492", -- Comments
    base04 = "#A0907D",
    base05 = "#64513E", -- FG
    base06 = "#786653",
    base07 = "#8C7B68",
    base08 = "#d09700", -- Variables
    base09 = "#64513E", -- numbers
    base0A = "#993333", -- Classes
    base0B = "#908D6A", -- Strings
    base0C = "#d09700", -- Support
    base0D = "#bf7979", -- Functions
    base0E = "#9e5581", -- Keywords
    base0F = "#75858c", -- Parentheses
  }
end

if vim.o.background == "dark" then
  palette = {
    base00 = "#242015",
    base01 = "#3A3124",
    base02 = "#4D3F32",
    base03 = "#5F4E41",
    base04 = "#B8A58C",
    base05 = "#D2C3A4",
    base06 = "#ebe0bb",
    base07 = "#F1E9D0",
    base08 = "#db930d",
    base09 = "#ebe0bb",
    base0A = "#a82d56",
    base0B = "#7a7653",
    base0C = "#db930d",
    base0D = "#c1666b",
    base0E = "#91506c",
    base0F = "#61a0a8",
  }
end

if palette then
  require('mini.base16').setup({ palette = palette })
  vim.g.colors_name = 'base16-swamp'
  vim.cmd [[ highlight WinSeparator guibg=None ]]
end
