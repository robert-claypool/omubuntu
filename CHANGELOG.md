# Changelog

All notable changes to omubuntu will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0-beta] - 2025-12-30

### Added
- Initial project structure with phase-based installers
- Terminal tools: zsh, neovim, lazygit, fzf, bat, eza, fd, ripgrep, zoxide, starship, gh
- Additional CLI tools: tldr, dust, duf, bottom, procs, yq, doggo, choose, atuin
- Dotfiles: .zshrc, starship.toml, alacritty.toml
- Desktop apps: Alacritty terminal
- Dev PC mode for EC2 instances with DCV
- GitHub release helpers for installing tools from releases
- CI pipeline with shellcheck and syntax validation
- Requirements table in README with tested Ubuntu versions
- Troubleshooting section in README

### Fixed
- Use jq instead of grep -P for JSON parsing (PCRE not available on Ubuntu by default)
- Handle missing USER environment variable in SSM contexts
- Correct asset regex patterns for GitHub releases (case sensitivity)
- Set HOME for atuin installer script
- Add shell directive for shellcheck (SC2148)
- Separate declaration and assignment in CLI (SC2155)

## [0.1.0] - 2025-12-30

### Added
- Initial alpha release
- Core installer framework
- Basic tool installation

[Unreleased]: https://github.com/robert-claypool/omubuntu/compare/v1.0.0-beta...HEAD
[1.0.0-beta]: https://github.com/robert-claypool/omubuntu/compare/v0.1.0...v1.0.0-beta
[0.1.0]: https://github.com/robert-claypool/omubuntu/releases/tag/v0.1.0
