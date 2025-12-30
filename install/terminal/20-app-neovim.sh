#!/bin/bash
# Install Neovim (latest stable from GitHub releases)

source "$OMUBUNTU_PATH/lib/core.sh"
source "$OMUBUNTU_PATH/lib/github.sh"

NVIM_VERSION="v0.10.2"

if has_command nvim; then
  log "Neovim already installed"
else
  log "Installing Neovim $NVIM_VERSION..."

  cd /tmp
  wget -q "https://github.com/neovim/neovim/releases/download/$NVIM_VERSION/nvim-linux64.tar.gz"
  tar xzf nvim-linux64.tar.gz

  # Install to /opt and symlink
  rm -rf /opt/nvim-linux64
  mv nvim-linux64 /opt/
  ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim

  rm -f nvim-linux64.tar.gz

  success "Neovim $NVIM_VERSION installed"
fi
