#!/bin/bash
# Install Chromium browser

source "$OMUBUNTU_PATH/lib/core.sh"
source "$OMUBUNTU_PATH/lib/apt.sh"

_os_id=""
if [[ -f /etc/os-release ]]; then
  # shellcheck disable=SC1091
  source /etc/os-release
  _os_id="${ID:-}"
fi

if [[ "$_os_id" == "ubuntu" ]]; then
  if has_command chromium || (has_command snap && snap list chromium &>/dev/null); then
    log "Chromium already installed"
  else
    if ! has_command snap; then
      log "Installing snapd (required for Chromium on Ubuntu)..."
      apt_install snapd
    fi

    log "Installing Chromium (snap)..."
    snap install chromium
    success "Chromium installed"
  fi
else
  if has_command chromium || has_command chromium-browser; then
    log "Chromium already installed"
  else
    log "Installing Chromium (apt)..."
    apt_install chromium
    success "Chromium installed"
  fi
fi
