#!/bin/bash
# Install Python 3 and uv (fast Python package manager)
# uv is 10-100x faster than pip and handles virtual environments better

source "$OMUBUNTU_PATH/lib/core.sh"
source "$OMUBUNTU_PATH/lib/apt.sh"

# Python 3 from apt
apt_install python3 python3-venv python3-dev

# uv - modern Python package manager
if ! has_command uv; then
  log "Installing uv..."
  curl -LsSf https://astral.sh/uv/install.sh | sh

  success "uv installed"
else
  log "uv already installed"
fi
