#!/bin/bash
# Install lazygit (Git TUI)

source "$OMUBUNTU_PATH/lib/core.sh"
source "$OMUBUNTU_PATH/lib/github.sh"

if has_command lazygit; then
  log "lazygit already installed"
else
  github_install_tar \
    "jesseduffield/lazygit" \
    "lazygit_.*_Linux_x86_64\.tar\.gz" \
    "lazygit"
fi
