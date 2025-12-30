#!/bin/bash
# Desktop apps phase runner
#
# Executes all scripts in install/desktop/ in lexical order.
# Each script is responsible for one app or a small related group.

source "$OMUBUNTU_PATH/lib/core.sh"
source "$OMUBUNTU_PATH/lib/apt.sh"

log "Installing desktop apps..."

# Run all app installers in order
for installer in "$OMUBUNTU_PATH/install/desktop/"*.sh; do
  if [[ -f "$installer" ]]; then
    log "Running $(basename "$installer")..."
    # shellcheck source=/dev/null
    source "$installer"
  fi
done

success "Desktop apps complete"
