# Neovim

## Installation

NOTE: Relevant tooling will be installed by Mason but you need certain system
packages, e.g `npm`, `go`, etc.; these can be installed trivially via Scoop on Windows or any Linux package manager.

#### Windows

```powershell
cd .\Documents\
git clone https://github.com/masroof-maindak/.dotfiles

$src = ".\.dotfiles\.config\nvim\"
cmd /c mklink /J "%LOCALAPPDATA%\nvim" "$src"

scoop bucket add extras
scoop install neovim neovide
```
