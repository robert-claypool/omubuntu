#!/bin/bash
# Install Bun - fast JavaScript runtime and package manager

source "$OMUBUNTU_PATH/lib/core.sh"

target_home="$(get_home)"
bun_install="$target_home/.bun"
bun_bin="$bun_install/bin/bun"

if [[ -x "$bun_bin" ]]; then
  log "Bun already installed: $($bun_bin --version)"
else
  log "Installing Bun..."
  as_user env HOME="$target_home" BUN_INSTALL="$bun_install" bash -lc 'curl -fsSL https://bun.sh/install | bash'

  # Add to PATH for current session
  export BUN_INSTALL="$bun_install"
  export PATH="$BUN_INSTALL/bin:$PATH"

  success "Bun $($bun_bin --version) installed"
fi
