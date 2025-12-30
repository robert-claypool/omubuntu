#!/bin/bash
# omubuntu installer - stable entrypoint
#
# This script is the public interface. Terraform/user_data calls this.
# Keep it minimal and stable. All logic lives in bin/omubuntu.
#
# Usage:
#   ./install.sh install --user robert --devpc
#   ./install.sh version
#   ./install.sh help

set -euo pipefail

# Resolve repo root (works even if called via symlink)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export OMUBUNTU_PATH="$SCRIPT_DIR"

# Delegate to CLI
exec "$OMUBUNTU_PATH/bin/omubuntu" "$@"
