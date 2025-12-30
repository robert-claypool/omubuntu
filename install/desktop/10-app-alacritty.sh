#!/bin/bash
# Install Alacritty terminal emulator

source "$OMUBUNTU_PATH/lib/core.sh"
source "$OMUBUNTU_PATH/lib/apt.sh"

if has_command alacritty; then
  log "Alacritty already installed"
else
  # Alacritty not in default Ubuntu repos - add PPA
  if ! grep -q "aslatter/ppa" /etc/apt/sources.list.d/*.list 2>/dev/null; then
    log "Adding Alacritty PPA..."
    add-apt-repository -y ppa:aslatter/ppa
    apt-get update -y
  fi

  apt_install alacritty

  # Set as default terminal (MATE desktop)
  if has_command gsettings; then
    as_user dbus-launch gsettings set org.mate.applications-terminal exec 'alacritty' 2>/dev/null || true
    as_user dbus-launch gsettings set org.mate.applications-terminal exec-arg '-e' 2>/dev/null || true
  fi

  # Update alternatives
  update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/bin/alacritty 50 2>/dev/null || true

  success "Alacritty installed"
fi
