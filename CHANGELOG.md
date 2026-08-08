# Changelog

All notable changes are documented here. Format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/); versioning is
[SemVer](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0] — 2026-05-19

### Added
- `init` subcommand: idempotent hook insertion into `~/.zshrc` with a backup.
- `apply <theme> [accent]` subcommand with bare-theme shortcut
  (`df-p10k-themes catppuccin-mocha peach`).
- `list`, `accents`, `current`, `uninstall`, `--help`, `--version`.
- Eight built-in themes: Catppuccin (Mocha/Frappé/Macchiato/Latte),
  Tokyo Night, One Dark Pro, Gruvbox Dark, Nord.
- Theme contract documented in `themes/_template.zsh`.
- Bats test suite covering CLI, init/uninstall, apply, installation, and themes.
- `Makefile` with `install`, `uninstall`, `test`, `lint`, `syntax` targets.

[Unreleased]: https://github.com/bladhl/df-p10k-themes/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/bladhl/df-p10k-themes/releases/tag/v0.1.0
