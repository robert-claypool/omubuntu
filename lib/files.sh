#!/bin/bash
# File synchronization helpers for configs and dotfiles

source "$OMUBUNTU_PATH/lib/core.sh"

# Sync files from files/rootfs/ to /
# These are system-wide configs (e.g., /etc/...)
sync_rootfs_files() {
  local src="$OMUBUNTU_PATH/files/rootfs"

  if [[ ! -d "$src" ]]; then
    return 0
  fi

  log "Syncing system configs to /..."

  # Use rsync if available, fall back to cp
  if has_command rsync; then
    rsync -av "$src/" /
  else
    cp -rv "$src/"* /
  fi
}

sync_managed_home_files() {
  local src="$OMUBUNTU_PATH/files/home/.config/omubuntu"
  local dest_home
  dest_home=$(get_home)
  local dest="$dest_home/.config/omubuntu"
  local user
  user=$(get_user)

  if [[ ! -d "$src" ]]; then
    return 0
  fi

  log "Syncing omubuntu managed configs to $dest (user: $user)..."

  # Ensure destination exists
  if [[ ! -d "$dest" ]]; then
    as_user mkdir -p "$dest"
  fi

  # Use rsync for clean updates (including deletes), fall back to manual copy
  if has_command rsync; then
    rsync -av --delete "$src/" "$dest/"
  else
    while IFS= read -r -d '' file; do
      local rel_path="${file#$src/}"
      local dest_path="$dest/$rel_path"
      local dest_dir
      dest_dir=$(dirname "$dest_path")

      if [[ ! -d "$dest_dir" ]]; then
        as_user mkdir -p "$dest_dir"
      fi

      cp "$file" "$dest_path"
    done < <(find "$src" -type f -print0)
  fi

  chown -R "$user:$user" "$dest"
}

# Sync dotfiles from files/home/ to user's home directory
# Safe semantics: only copy if destination doesn't exist (don't clobber)
sync_home_files() {
  local src="$OMUBUNTU_PATH/files/home"
  local dest
  dest=$(get_home)
  local user
  user=$(get_user)

  if [[ ! -d "$src" ]]; then
    return 0
  fi

  log "Syncing dotfiles to $dest (user: $user)..."

  # Walk the source tree and copy files that don't exist at destination
  while IFS= read -r -d '' file; do
    local rel_path="${file#$src/}"

    # Managed overlay (updated separately; don't safe-sync it)
    if [[ "$rel_path" == .config/omubuntu/* ]]; then
      continue
    fi

    local dest_path="$dest/$rel_path"
    local dest_dir
    dest_dir=$(dirname "$dest_path")

    # Create parent directories if needed
    if [[ ! -d "$dest_dir" ]]; then
      as_user mkdir -p "$dest_dir"
    fi

    # Only copy if destination doesn't exist (safe, don't clobber)
    if [[ ! -e "$dest_path" ]]; then
      log "  Creating $rel_path"
      cp "$file" "$dest_path"
      chown "$user:$user" "$dest_path"
    else
      log "  Skipping $rel_path (already exists)"
    fi
  done < <(find "$src" -type f -print0)
}

# Force sync a specific config file (overwrites if exists)
# Usage: sync_config_file source_path dest_path [owner]
sync_config_file() {
  local src="$1"
  local dest="$2"
  local owner="${3:-}"

  local dest_dir
  dest_dir=$(dirname "$dest")

  mkdir -p "$dest_dir"
  cp "$src" "$dest"

  if [[ -n "$owner" ]]; then
    chown "$owner:$owner" "$dest"
  fi

  log "Synced $dest"
}

# Ensure a directory exists with correct ownership
# Usage: ensure_dir path [owner]
ensure_dir() {
  local path="$1"
  local owner="${2:-}"

  if [[ ! -d "$path" ]]; then
    mkdir -p "$path"
  fi

  if [[ -n "$owner" ]]; then
    chown "$owner:$owner" "$path"
  fi
}
