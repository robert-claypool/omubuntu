#!/bin/bash
# Additional modern CLI tools

source "$OMUBUNTU_PATH/lib/core.sh"
source "$OMUBUNTU_PATH/lib/apt.sh"
source "$OMUBUNTU_PATH/lib/github.sh"

# tldr - simplified man pages
apt_install tldr

# dust - disk usage analyzer
if ! has_command dust; then
  github_install_tar \
    "bootandy/dust" \
    "dust-v.*-x86_64-unknown-linux-gnu\.tar\.gz" \
    "dust"
fi

# duf - disk usage/free utility
if ! has_command duf; then
  github_install_deb \
    "muesli/duf" \
    "duf_.*_linux_amd64\.deb"
fi

# bottom (btm) - system monitor
if ! has_command btm; then
  github_install_deb \
    "ClementTsang/bottom" \
    "bottom_.*_amd64\.deb"
fi

# procs - modern ps replacement
if ! has_command procs; then
  log "Installing procs..."
  local tmp_zip="/tmp/procs.zip"
  github_download_asset "dalance/procs" "procs-v.*-x86_64-linux\.zip" "$tmp_zip"
  unzip -o "$tmp_zip" -d /usr/local/bin
  rm -f "$tmp_zip"
  success "Installed procs"
fi

# yq - YAML processor
if ! has_command yq; then
  github_install_binary \
    "mikefarah/yq" \
    "yq_linux_amd64" \
    "yq"
fi

# doggo - DNS client
if ! has_command doggo; then
  github_install_tar \
    "mr-karan/doggo" \
    "doggo_.*_linux_amd64\.tar\.gz" \
    "doggo"
fi

# choose - field selection (cut alternative)
if ! has_command choose; then
  github_install_binary \
    "theryangeary/choose" \
    "choose-x86_64-unknown-linux-gnu" \
    "choose"
fi

# atuin - shell history with sync
if ! has_command atuin; then
  log "Installing atuin..."
  curl -sS https://raw.githubusercontent.com/atuinsh/atuin/main/install.sh | bash
  mv ~/.atuin/bin/atuin /usr/local/bin/ 2>/dev/null || true
  success "Installed atuin"
fi

success "Additional CLI tools installed"
