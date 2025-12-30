#!/bin/bash
# Install extra CLI tools: jq, tmux, delta

source "$OMUBUNTU_PATH/lib/core.sh"
source "$OMUBUNTU_PATH/lib/apt.sh"
source "$OMUBUNTU_PATH/lib/github.sh"

# APT packages
apt_install jq tmux sqlite3

# delta (better git diffs) - from GitHub releases
if ! has_command delta; then
  github_install_deb \
    "dandavison/delta" \
    "git-delta_.*_amd64\.deb"
fi

success "CLI extras installed"
