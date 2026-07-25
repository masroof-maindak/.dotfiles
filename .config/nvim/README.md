# Neovim

## Installation

NOTE: Relevant tooling will be installed by Mason but you need certain system
packages, e.g `npm`, `go`, etc.; these can be installed trivially via Scoop on
Windows or any Linux package manager.

Regarding Neovim itself, if you do not have a sufficiently up-to-date version,
e.g as is the case for Ubuntu repositories, the easiest way to get a modern
version is using `snap`.

```bash
sudo snap install nvim --classic
```

On Windows, Neovim can be installed using `scoop`:

```pwsh
scoop bucket add extras
scoop install neovim neovide
```

### Windows

#### Bootstrap

```powershell
cd .\Documents\
git clone https://github.com/masroof-maindak/.dotfiles

$src = ".\.dotfiles\.config\nvim\"
cmd /c mklink /J "%LOCALAPPDATA%\nvim" "$src"
```

#### Setting up tree-sitter

```pwsh
scoop install tree-sitter
tree-sitter init-config
```

- Download the 'Build Tools for Visual Studio <20xx>' from
  [VS' site](https://visualstudio.microsoft.com/downloads/); 2026 version
  [here](https://visualstudio.microsoft.com/downloads/#build-tools-for-visual-studio-2026)

```pwsh
.\vs_BuildTools.exe --add Microsoft.VisualStudio.Component.VC.Tools.x86.x64 --add Microsoft.VisualStudio.Component.Windows11SDK.26100
```

- Go through the menus, and install only the MSVC toolset + Windows SDK

## Acknowledgements

- <https://gist.github.com/aont/f5191dc4699a708bd72e65273921b6a8>
