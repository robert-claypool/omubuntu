#!/bin/bash
# GitHub release download helpers
#
# Centralizes the "fetch latest release, download asset" pattern
# so app scripts stay short and consistent.

source "$OMUBUNTU_PATH/lib/core.sh"

_github_api_get() {
  local endpoint="$1"
  local url

  if [[ "$endpoint" == http* ]]; then
    url="$endpoint"
  else
    url="https://api.github.com/$endpoint"
  fi

  local tmp_file
  tmp_file="$(mktemp)"

  local curl_args=(
    -sS
    -L
    -o "$tmp_file"
    -w "%{http_code}"
    -H "Accept: application/vnd.github+json"
  )

  if [[ -n "${GITHUB_TOKEN:-}" ]]; then
    curl_args+=(-H "Authorization: Bearer ${GITHUB_TOKEN}")
  fi

  local http_code
  if ! http_code="$(curl "${curl_args[@]}" "$url")"; then
    rm -f "$tmp_file"
    die "GitHub API request failed (curl error) for $url"
  fi

  local body
  body="$(cat "$tmp_file")"
  rm -f "$tmp_file"

  if [[ "$http_code" == "200" ]]; then
    printf "%s" "$body"
    return 0
  fi

  local message doc_url
  message="$(echo "$body" | jq -r '.message // empty' 2>/dev/null || true)"
  doc_url="$(echo "$body" | jq -r '.documentation_url // empty' 2>/dev/null || true)"

  if [[ "$http_code" == "403" && "$message" == *"rate limit"* ]]; then
    if [[ -n "${GITHUB_TOKEN:-}" ]]; then
      die "GitHub API rate limit exceeded for provided GITHUB_TOKEN. $message${doc_url:+ ($doc_url)}"
    else
      die "GitHub API rate limit exceeded (unauthenticated). Set GITHUB_TOKEN and re-run. $message${doc_url:+ ($doc_url)}"
    fi
  fi

  if [[ "$http_code" == "401" && "$message" == *"Bad credentials"* ]]; then
    die "GitHub API authentication failed (Bad credentials). Check your GITHUB_TOKEN."
  fi

  if [[ -n "$message" ]]; then
    die "GitHub API request failed (HTTP $http_code) for $url: $message${doc_url:+ ($doc_url)}"
  fi

  die "GitHub API request failed (HTTP $http_code) for $url"
}

# Get the latest release tag for a GitHub repo
# Usage: github_latest_tag owner/repo
# Returns: tag name (e.g., "v1.2.3")
github_latest_tag() {
  local repo="$1"
  local release_json
  release_json="$(_github_api_get repos/$repo/releases/latest)"

  local tag
  tag="$(echo "$release_json" | jq -r '.tag_name // empty' 2>/dev/null)" || die "Failed to parse latest release tag for $repo"
  if [[ -z "$tag" ]]; then
    die "Could not determine latest release tag for $repo"
  fi

  echo "$tag"
}

# Get the latest release tag, stripping the 'v' prefix
# Usage: github_latest_version owner/repo
# Returns: version number (e.g., "1.2.3")
github_latest_version() {
  local repo="$1"
  github_latest_tag "$repo" | tr -d 'v'
}

# Download a release asset matching a pattern
# Usage: github_download_asset owner/repo asset_regex output_path
# Example: github_download_asset "cli/cli" "gh_.*_linux_amd64\.deb" /tmp/gh.deb
github_download_asset() {
  local repo="$1"
  local asset_regex="$2"
  local output_path="$3"

  local release_json
  release_json="$(_github_api_get repos/$repo/releases/latest)"

  local tag
  tag="$(echo "$release_json" | jq -r '.tag_name // empty' 2>/dev/null)" || die "Failed to parse latest release tag for $repo"
  if [[ -z "$tag" ]]; then
    die "Could not determine latest release tag for $repo"
  fi

  local asset_urls
  asset_urls="$(echo "$release_json" | jq -r '.assets[].browser_download_url' 2>/dev/null)" || die "Failed to parse release assets for $repo $tag"

  local download_url
  download_url="$(echo "$asset_urls" | grep -E -- "$asset_regex" | head -1)"

  if [[ -z "$download_url" ]]; then
    die "Could not find asset matching '$asset_regex' for $repo"
  fi

  log "Downloading $repo $tag..."
  if ! curl -fsSL "$download_url" -o "$output_path"; then
    die "Failed to download asset from $download_url"
  fi
}

# Install a GitHub release as a .deb package
# Usage: github_install_deb owner/repo asset_regex
# Example: github_install_deb "cli/cli" "gh_.*_linux_amd64\.deb"
github_install_deb() {
  local repo="$1"
  local asset_regex="$2"
  local tmp_deb
  tmp_deb="/tmp/$(basename "$repo").deb"

  github_download_asset "$repo" "$asset_regex" "$tmp_deb"

  source "$OMUBUNTU_PATH/lib/apt.sh"
  deb_install "$tmp_deb"
  rm -f "$tmp_deb"
}

# Install a GitHub release from a tarball containing a binary
# Usage: github_install_tar owner/repo asset_regex binary_name [install_path]
# Example: github_install_tar "junegunn/fzf" "fzf-.*-linux_amd64.tar.gz" "fzf"
github_install_tar() {
  local repo="$1"
  local asset_regex="$2"
  local binary_name="$3"
  local install_path="${4:-/usr/local/bin}"

  local tmp_dir
  tmp_dir="/tmp/omubuntu-$(basename "$repo")"
  local tmp_tar="$tmp_dir/archive.tar.gz"

  mkdir -p "$tmp_dir"
  github_download_asset "$repo" "$asset_regex" "$tmp_tar"

  tar -xzf "$tmp_tar" -C "$tmp_dir"

  # Find the binary (might be in a subdirectory)
  local binary_path
  binary_path=$(find "$tmp_dir" -name "$binary_name" -type f | head -1)

  if [[ -z "$binary_path" ]]; then
    die "Could not find '$binary_name' in tarball for $repo"
  fi

  install -m 755 "$binary_path" "$install_path/$binary_name"
  rm -rf "$tmp_dir"

  success "Installed $binary_name to $install_path"
}

# Install a single binary directly from GitHub releases
# Usage: github_install_binary owner/repo asset_regex binary_name [install_path]
github_install_binary() {
  local repo="$1"
  local asset_regex="$2"
  local binary_name="$3"
  local install_path="${4:-/usr/local/bin}"

  local tmp_bin="/tmp/$binary_name"
  github_download_asset "$repo" "$asset_regex" "$tmp_bin"

  install -m 755 "$tmp_bin" "$install_path/$binary_name"
  rm -f "$tmp_bin"

  success "Installed $binary_name to $install_path"
}
