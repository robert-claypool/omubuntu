#!/bin/bash
# Install modern CLI tools (Rust-based replacements)

source "$OMUBUNTU_PATH/lib/core.sh"
source "$OMUBUNTU_PATH/lib/apt.sh"
source "$OMUBUNTU_PATH/lib/github.sh"

# APT-available tools
apt_install \
  ripgrep \
  fd-find \
  bat \
  fzf \
  direnv \
  trash-cli

# Create standard symlinks for tools with different package names
ln -sf /usr/bin/batcat /usr/local/bin/bat 2>/dev/null || true
ln -sf /usr/bin/fdfind /usr/local/bin/fd 2>/dev/null || true

# eza (modern ls) - from GitHub releases
if ! has_command eza; then
  github_install_tar \
    "eza-community/eza" \
    "eza_x86_64-unknown-linux-gnu\.tar\.gz" \
    "eza"
fi

# zoxide (smart cd) - from GitHub releases
if ! has_command zoxide; then
  github_install_tar \
    "ajeetdsouza/zoxide" \
    "zoxide-.*-x86_64-unknown-linux-musl\.tar\.gz" \
    "zoxide"
fi

# starship (prompt) - official installer
if ! has_command starship; then
  log "Installing starship..."
  curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

success "Modern CLI tools installed"
