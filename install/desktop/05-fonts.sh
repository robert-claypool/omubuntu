#!/bin/bash
# Install Nerd Fonts (JetBrainsMono)

source "$OMUBUNTU_PATH/lib/core.sh"
source "$OMUBUNTU_PATH/lib/apt.sh"
source "$OMUBUNTU_PATH/lib/github.sh"

FONT_DIR="/usr/share/fonts/truetype/jetbrains-mono-nerd"

if [[ -d "$FONT_DIR" ]]; then
  log "JetBrainsMono Nerd Font already installed"
else
  log "Installing JetBrainsMono Nerd Font..."

  # Ensure fontconfig is installed
  apt_install fontconfig

  mkdir -p "$FONT_DIR"

  local tmp_zip="/tmp/JetBrainsMono.zip"
  github_download_asset \
    "ryanoasis/nerd-fonts" \
    "JetBrainsMono\.zip" \
    "$tmp_zip"

  unzip -o "$tmp_zip" -d "$FONT_DIR"
  rm -f "$tmp_zip"

  # Refresh font cache
  fc-cache -fv

  success "JetBrainsMono Nerd Font installed"
fi
