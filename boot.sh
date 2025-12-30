#!/bin/bash
# omubuntu bootstrap script
#
# Run this on a fresh Ubuntu system:
#   wget -qO- https://raw.githubusercontent.com/robert-claypool/omubuntu/main/boot.sh | bash

set -e

echo "
                        _                 _
  ___  _ __ ___  _   _| |__  _   _ _ __ | |_ _   _
 / _ \| '_ \` _ \| | | | '_ \| | | | '_ \| __| | | |
| (_) | | | | | | |_| | |_) | |_| | | | | |_| |_| |
 \___/|_| |_| |_|\__,_|_.__/ \__,_|_| |_|\__|\__,_|

"
echo "=> omubuntu is for fresh Ubuntu 22.04+ installations"
echo ""
echo "Begin installation (or abort with ctrl+c)..."
echo ""

# Install git if needed
sudo apt-get update >/dev/null
sudo apt-get install -y git >/dev/null

# Clone repo
echo "Cloning omubuntu..."
rm -rf ~/.local/share/omubuntu
git clone https://github.com/robert-claypool/omubuntu.git ~/.local/share/omubuntu >/dev/null

# Checkout specific ref if provided
if [[ -n "${OMUBUNTU_REF:-}" ]]; then
  cd ~/.local/share/omubuntu
  git fetch origin "$OMUBUNTU_REF" && git checkout "$OMUBUNTU_REF"
  cd -
fi

# Run installer
echo "Starting installation..."
cd ~/.local/share/omubuntu
sudo ./install.sh install --user "$USER"
