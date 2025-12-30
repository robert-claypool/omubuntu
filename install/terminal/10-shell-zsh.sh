#!/bin/bash
# Install ZSH and set as default shell

source "$OMUBUNTU_PATH/lib/apt.sh"
source "$OMUBUNTU_PATH/lib/core.sh"

if has_command zsh; then
  log "ZSH already installed"
else
  apt_install zsh

  # Set ZSH as default shell for target user
  local user
  user=$(get_user)
  chsh -s /usr/bin/zsh "$user"

  success "ZSH installed and set as default shell"
fi
