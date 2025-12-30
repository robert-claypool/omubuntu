#!/bin/bash
# Install Bun - fast JavaScript runtime and package manager

source "$OMUBUNTU_PATH/lib/core.sh"

if has_command bun; then
  log "Bun already installed: $(bun --version)"
else
  log "Installing Bun..."
  curl -fsSL https://bun.sh/install | bash

  # Add to PATH for current session
  export BUN_INSTALL="$HOME/.bun"
  export PATH="$BUN_INSTALL/bin:$PATH"

  success "Bun $(bun --version) installed"
fi
