#!/bin/bash
# Install GitHub CLI

source "$OMUBUNTU_PATH/lib/core.sh"
source "$OMUBUNTU_PATH/lib/github.sh"

if has_command gh; then
  log "GitHub CLI already installed"
else
  github_install_deb \
    "cli/cli" \
    "gh_.*_linux_amd64\.deb"
fi
