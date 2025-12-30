# omubuntu

> **Alpha Release** - This project is under active development. APIs and tool selections may change. Tested on Ubuntu 22.04 LTS.

Omarchy-style developer environment for Ubuntu. Transform a fresh Ubuntu installation into a delightful, opinionated development system.

Inspired by [Omakub](https://github.com/basecamp/omakub) and [Omarchy](https://github.com/basecamp/omarchy) by DHH.

## Quick Start

```bash
# On a fresh Ubuntu 22.04+ system
wget -qO- https://raw.githubusercontent.com/robert-claypool/omubuntu/main/boot.sh | bash
```

Or clone and run:

```bash
git clone https://github.com/robert-claypool/omubuntu.git ~/.local/share/omubuntu
cd ~/.local/share/omubuntu
sudo ./install.sh install --user $USER
```

## What's Included

### Terminal Tools
- **Shell**: ZSH with Starship prompt
- **Editor**: Neovim 0.10+
- **Git**: lazygit, GitHub CLI
- **Modern CLI**: eza, fd, ripgrep, bat, fzf, zoxide, atuin

### Desktop Apps
- **Terminal**: Alacritty (Tokyo Night theme)

### Dotfiles
- `.zshrc` with sensible defaults and aliases
- `starship.toml` minimal prompt
- `alacritty.toml` with Tokyo Night theme

## Usage

```bash
# Full install (terminal + desktop)
sudo ./install.sh install --user alice

# Terminal tools only
sudo ./install.sh install --user alice --no-desktop

# For EC2 dev PCs (includes DCV hooks)
sudo ./install.sh install --user robert --devpc

# Force reinstall
sudo ./install.sh install --user alice --force
```

## Adding Tools

Add a new script in `install/terminal/` or `install/desktop/`:

```bash
# install/terminal/99-app-mytool.sh
#!/bin/bash
source "$OMUBUNTU_PATH/lib/core.sh"
source "$OMUBUNTU_PATH/lib/github.sh"

if ! has_command mytool; then
  github_install_tar "owner/mytool" "mytool_.*_linux_amd64\.tar\.gz" "mytool"
fi
```

Scripts run in lexical order (use numeric prefixes for ordering).

## Structure

```
omubuntu/
  install.sh              # Stable entrypoint
  bin/omubuntu            # CLI (bash now, Go later)
  lib/                    # Shared helpers
    core.sh               # Logging, require_root, etc.
    apt.sh                # APT package helpers
    github.sh             # GitHub release helpers
    files.sh              # Config file sync
    state.sh              # Installation markers
  install/
    terminal.sh           # Phase runner
    desktop.sh            # Phase runner
    terminal/*.sh         # One script per tool
    desktop/*.sh          # One script per app
  files/
    home/                 # Dotfiles (copied to $HOME)
    rootfs/               # System configs (copied to /)
```

## Philosophy

- **Opinionated defaults**: We make the choices so you don't have to
- **One script per tool**: Easy to understand, modify, or remove
- **Safe dotfiles**: Only copied if destination doesn't exist
- **Apply once**: Fresh VMs get new configs; existing are left alone

## Versioning

This project uses [Semantic Versioning](https://semver.org/). See [CHANGELOG.md](CHANGELOG.md) for release history.

- **0.x.x** - Alpha: Active development, breaking changes expected
- **1.0.0** - Beta: Feature complete, stabilizing
- **1.x.x** - Stable: Production ready

## License

MIT
