#!/bin/bash
# Install ZSH and set as default shell

source "$OMUBUNTU_PATH/lib/apt.sh"
source "$OMUBUNTU_PATH/lib/core.sh"

if has_command zsh; then
  log "ZSH already installed"
else
  apt_install zsh
  success "ZSH installed"
fi

# Always ensure ZSH is the default shell (even if zsh was already installed)
_user=$(get_user)
_current_shell=$(getent passwd "$_user" | cut -d: -f7)

if [[ "$_current_shell" != "/usr/bin/zsh" ]]; then
  log "Setting ZSH as default shell for $_user..."
  chsh -s /usr/bin/zsh "$_user"
  success "ZSH set as default shell"
else
  log "ZSH already default shell for $_user"
fi
