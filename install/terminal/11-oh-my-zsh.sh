#!/bin/bash
# Install oh-my-zsh and popular plugins

source "$OMUBUNTU_PATH/lib/core.sh"
source "$OMUBUNTU_PATH/lib/apt.sh"

_user=$(get_user)
_home=$(get_home)
_omz_dir="$_home/.oh-my-zsh"

if [[ -d "$_omz_dir" ]]; then
  log "oh-my-zsh already installed"
else
  log "Installing oh-my-zsh..."

  # Install dependencies
  apt_install git curl

  # Install oh-my-zsh (unattended)
  as_user sh -c 'RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"'

  success "oh-my-zsh installed"
fi

# Install popular plugins
_custom_plugins="$_omz_dir/custom/plugins"

# zsh-autosuggestions - widely adopted, suggests commands as you type
if [[ ! -d "$_custom_plugins/zsh-autosuggestions" ]]; then
  log "Installing zsh-autosuggestions..."
  as_user git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$_custom_plugins/zsh-autosuggestions"
fi

# zsh-syntax-highlighting - widely adopted, highlights valid/invalid commands
if [[ ! -d "$_custom_plugins/zsh-syntax-highlighting" ]]; then
  log "Installing zsh-syntax-highlighting..."
  as_user git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting "$_custom_plugins/zsh-syntax-highlighting"
fi

# zsh-completions - additional completion definitions
if [[ ! -d "$_custom_plugins/zsh-completions" ]]; then
  log "Installing zsh-completions..."
  as_user git clone --depth=1 https://github.com/zsh-users/zsh-completions "$_custom_plugins/zsh-completions"
fi

success "oh-my-zsh plugins installed"
