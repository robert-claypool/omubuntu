#!/bin/bash
# Install Google Chrome browser
# Using Chrome instead of Chromium snap because snaps have sandbox/AppArmor
# issues with DCV virtual sessions and other non-standard X environments.

source "$OMUBUNTU_PATH/lib/core.sh"
source "$OMUBUNTU_PATH/lib/apt.sh"

if has_command google-chrome || has_command google-chrome-stable; then
  log "Google Chrome already installed"
else
  log "Installing Google Chrome..."

  # Download and install the official Google Chrome deb
  tmp_deb="/tmp/google-chrome-stable.deb"
  curl -fsSL "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb" -o "$tmp_deb"

  # Install with apt to handle dependencies
  apt_install "$tmp_deb"
  rm -f "$tmp_deb"

  success "Google Chrome installed"
fi
