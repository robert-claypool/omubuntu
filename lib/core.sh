#!/bin/bash
# Core utilities for omubuntu scripts

# Colors (disabled if not a terminal)
if [[ -t 1 ]]; then
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  YELLOW='\033[0;33m'
  BLUE='\033[0;34m'
  NC='\033[0m' # No Color
else
  RED=''
  GREEN=''
  YELLOW=''
  BLUE=''
  NC=''
fi

# Log a message with timestamp
log() {
  echo -e "${BLUE}[omubuntu]${NC} $*"
}

# Log a warning
warn() {
  echo -e "${YELLOW}[omubuntu]${NC} WARNING: $*" >&2
}

# Log an error and exit
die() {
  echo -e "${RED}[omubuntu]${NC} ERROR: $*" >&2
  exit 1
}

# Log success
success() {
  echo -e "${GREEN}[omubuntu]${NC} $*"
}

# Check if running as root
require_root() {
  if [[ $EUID -ne 0 ]]; then
    die "This script must be run as root (use sudo)"
  fi
}

# Check if a command exists
has_command() {
  command -v "$1" &>/dev/null
}

# Run a command, logging it first
run() {
  log "Running: $*"
  "$@"
}

# Get the target user (set by CLI)
get_user() {
  echo "${OMUBUNTU_USER:-$USER}"
}

# Get the target user's home directory
get_home() {
  echo "${OMUBUNTU_HOME:-$HOME}"
}

# Run a command as the target user (when we're root but need user context)
as_user() {
  local user
  user=$(get_user)
  if [[ $EUID -eq 0 ]] && [[ "$user" != "root" ]]; then
    sudo -u "$user" "$@"
  else
    "$@"
  fi
}
