#!/bin/bash
# Install AWS CLI v2

source "$OMUBUNTU_PATH/lib/core.sh"

if has_command aws; then
  log "AWS CLI already installed: $(aws --version)"
else
  log "Installing AWS CLI v2..."

  curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o /tmp/awscliv2.zip
  unzip -q /tmp/awscliv2.zip -d /tmp
  /tmp/aws/install
  rm -rf /tmp/awscliv2.zip /tmp/aws

  success "AWS CLI $(aws --version) installed"
fi
