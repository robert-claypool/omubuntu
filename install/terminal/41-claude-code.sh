#!/bin/bash
# Install Claude Code CLI

source "$OMUBUNTU_PATH/lib/core.sh"

if has_command claude; then
  log "Claude Code already installed"
else
  if ! has_command npm; then
    warn "npm not found - skipping Claude Code (install Node.js first)"
    return 0
  fi

  log "Installing Claude Code CLI..."
  npm install -g @anthropic-ai/claude-code

  success "Claude Code installed"
fi
