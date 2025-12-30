#!/bin/bash
# Install Alacritty terminal emulator

source "$OMUBUNTU_PATH/lib/core.sh"
source "$OMUBUNTU_PATH/lib/apt.sh"

if has_command alacritty; then
  log "Alacritty already installed"
else
  apt_install alacritty

  # Set as default terminal (MATE desktop)
  if has_command gsettings; then
    local user
    user=$(get_user)
    as_user dbus-launch gsettings set org.mate.applications-terminal exec 'alacritty' 2>/dev/null || true
    as_user dbus-launch gsettings set org.mate.applications-terminal exec-arg '-e' 2>/dev/null || true
  fi

  # Update alternatives
  update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/alacritty 50 2>/dev/null || true

  success "Alacritty installed"
fi
