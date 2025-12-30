#!/bin/bash
# Install Go programming language

source "$OMUBUNTU_PATH/lib/core.sh"

GO_VERSION="1.23.4"

if has_command go; then
  log "Go already installed: $(go version)"
else
  log "Installing Go $GO_VERSION..."

  curl -fsSL "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" -o /tmp/go.tar.gz
  rm -rf /usr/local/go
  tar -C /usr/local -xzf /tmp/go.tar.gz
  rm /tmp/go.tar.gz

  # Symlink to PATH
  ln -sf /usr/local/go/bin/go /usr/local/bin/go
  ln -sf /usr/local/go/bin/gofmt /usr/local/bin/gofmt

  success "Go $GO_VERSION installed"
fi
