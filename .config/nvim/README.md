# Neovim

## Installation

NOTE: Relevant tooling will be installed by Mason but you need certain system
packages, e.g `npm`, `go`, etc.; these can be installed trivially via Scoop or
any Linux package manager.

#### Windows

```powershell
mkdir $env:LOCALAPPDATA\nvim
cd $env:LOCALAPPDATA\nvim
# Clone repo and mklink/copy `.config/nvim` to the above dir
scoop bucket add extras
scoop install neovim neovide
```
