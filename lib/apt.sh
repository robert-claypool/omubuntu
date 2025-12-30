#!/bin/bash
# APT package management helpers

source "$OMUBUNTU_PATH/lib/core.sh"

# Track if we've updated apt in this session
APT_UPDATED=false

# Update apt package lists (once per session)
apt_update() {
  if [[ "$APT_UPDATED" == "false" ]]; then
    log "Updating apt package lists..."
    apt-get update -y
    APT_UPDATED=true
  fi
}

# Install packages via apt
# Usage: apt_install package1 package2 ...
apt_install() {
  apt_update
  log "Installing apt packages: $*"
  DEBIAN_FRONTEND=noninteractive apt-get install -y "$@"
}

# Check if a package is installed
apt_is_installed() {
  dpkg -l "$1" 2>/dev/null | grep -q "^ii"
}

# Install a .deb file
# Usage: deb_install /path/to/package.deb
deb_install() {
  local deb_path="$1"
  log "Installing deb: $deb_path"
  dpkg -i "$deb_path" || true
  apt-get install -f -y  # Fix any dependency issues
}

# Add an apt repository
# Usage: apt_add_repo "deb [signed-by=/path/to/key.gpg] https://example.com/repo stable main"
apt_add_repo() {
  local repo="$1"
  local list_file="$2"
  echo "$repo" > "/etc/apt/sources.list.d/$list_file"
  APT_UPDATED=false  # Force update after adding repo
}
