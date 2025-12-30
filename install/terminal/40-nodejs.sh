#!/bin/bash
# Install Node.js (required for Claude Code and other tools)

source "$OMUBUNTU_PATH/lib/core.sh"
source "$OMUBUNTU_PATH/lib/apt.sh"

if has_command node; then
  log "Node.js already installed: $(node --version)"
else
  log "Installing Node.js 22.x..."

  # Add NodeSource repository
  curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
  apt_install nodejs

  success "Node.js $(node --version) installed"
fi
