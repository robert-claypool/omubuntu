#!/bin/bash
# Installation state management
#
# Implements "apply once" semantics via marker files.
# New VMs get fresh configs; existing VMs are left alone.

source "$OMUBUNTU_PATH/lib/core.sh"

# Where we store state
STATE_DIR="/var/lib/omubuntu"
STATE_FILE="$STATE_DIR/installed.json"

# Check if omubuntu has been installed
# Returns 0 (true) if installed, 1 (false) if not
state_is_installed() {
  [[ -f "$STATE_FILE" ]]
}

# Get the installed version (or empty if not installed)
state_get_version() {
  if state_is_installed; then
    grep -Po '"version": "\K[^"]*' "$STATE_FILE" 2>/dev/null || echo ""
  else
    echo ""
  fi
}

# Mark omubuntu as installed
# Usage: state_write_installed version
state_write_installed() {
  local version="$1"
  local timestamp
  timestamp=$(date -Iseconds)

  mkdir -p "$STATE_DIR"

  cat > "$STATE_FILE" <<EOF
{
  "version": "$version",
  "installed_at": "$timestamp",
  "user": "$(get_user)"
}
EOF

  log "Wrote installation marker: $STATE_FILE"
}

# Clear installation state (for testing or forced reinstall)
state_clear() {
  rm -f "$STATE_FILE"
  log "Cleared installation state"
}

# Per-user state (for dotfiles that shouldn't be reapplied)
USER_STATE_DIR=".local/share/omubuntu"
USER_STATE_FILE="installed.json"

state_user_is_installed() {
  local home
  home=$(get_home)
  [[ -f "$home/$USER_STATE_DIR/$USER_STATE_FILE" ]]
}

state_user_write_installed() {
  local version="$1"
  local home
  home=$(get_home)
  local user
  user=$(get_user)
  local state_dir="$home/$USER_STATE_DIR"
  local state_file="$state_dir/$USER_STATE_FILE"
  local timestamp
  timestamp=$(date -Iseconds)

  as_user mkdir -p "$state_dir"

  cat > "$state_file" <<EOF
{
  "version": "$version",
  "installed_at": "$timestamp"
}
EOF

  chown "$user:$user" "$state_file"
}
