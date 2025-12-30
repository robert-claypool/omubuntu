#!/bin/bash
# Install database clients: PostgreSQL, SQLite

source "$OMUBUNTU_PATH/lib/core.sh"
source "$OMUBUNTU_PATH/lib/apt.sh"

# PostgreSQL client (psql) - latest from PostgreSQL APT repo
if ! has_command psql; then
  log "Adding PostgreSQL APT repository..."
  apt_install curl ca-certificates
  curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /usr/share/keyrings/postgresql-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/postgresql-keyring.gpg] http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list
  apt-get update -qq
fi

apt_install postgresql-client sqlite3

success "Database clients installed"
