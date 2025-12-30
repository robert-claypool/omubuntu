#!/bin/bash
# Install Terraform from HashiCorp APT repository

source "$OMUBUNTU_PATH/lib/core.sh"
source "$OMUBUNTU_PATH/lib/apt.sh"

if has_command terraform; then
  log "Terraform already installed: $(terraform version -json | jq -r '.terraform_version')"
else
  log "Adding HashiCorp APT repository..."

  apt_install gnupg software-properties-common

  curl -fsSL https://apt.releases.hashicorp.com/gpg | gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" > /etc/apt/sources.list.d/hashicorp.list
  apt-get update -qq

  apt_install terraform

  success "Terraform $(terraform version -json | jq -r '.terraform_version') installed"
fi
