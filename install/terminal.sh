#!/bin/bash
# Terminal tools phase runner
#
# Executes all scripts in install/terminal/ in lexical order.
# Each script is responsible for one tool or a small related group.

source "$OMUBUNTU_PATH/lib/core.sh"
source "$OMUBUNTU_PATH/lib/apt.sh"

log "Installing terminal tools..."

# Install base packages first (dependencies for other tools)
apt_install \
  curl \
  wget \
  git \
  unzip \
  zip \
  build-essential \
  jq \
  htop \
  tmux

# Run all app installers in order
for installer in "$OMUBUNTU_PATH/install/terminal/"*.sh; do
  if [[ -f "$installer" ]]; then
    log "Running $(basename "$installer")..."
    # shellcheck source=/dev/null
    source "$installer"
  fi
done

success "Terminal tools complete"
