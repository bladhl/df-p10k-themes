# Changelog

All notable changes are documented here. Format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/); versioning is
[SemVer](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Per-OS coloring of the `os_icon` segment: the detected distribution or
  platform is mapped to the closest hue in the active palette (Ubuntu orange,
  Android green, Debian red, …), falling back to the theme accent.
- Seven themes: Dracula, Rosé Pine, Rosé Pine Dawn, Kanagawa, Everforest Dark,
  Solarized Dark, Solarized Light — bringing the total to fifteen, three of
  them light.
- `scripts/capture-screenshots.sh` and `make screenshots`: an optional helper
  that captures previews with vhs in a throwaway sandbox, using p10k's own
  `lean` preset so shots match what users actually run. `THEME=<name>`
  captures a single theme. Previews may also be taken by hand.
- A preview for every theme, dark and light, in the README. Previews are
  contributor-captured, so the `os_icon` varies by whoever made it.
- A test enforcing that any preview in the gallery is a 1400x260 PNG named
  after an existing theme, however it was produced.
- `CONTRIBUTING.md`, issue and pull request templates, and a GitHub Actions
  workflow running `make lint`, `make syntax`, and `make test` on Linux and
  macOS.

### Changed
- `make lint` now covers `install.sh` and `scripts/capture-screenshots.sh`,
  not just the CLI.

### Removed
- `palette`, a scratch file of raw palette notes that was not consumed by any
  code path.
- The two hand-taken screenshots, superseded by the generated gallery.

## [0.1.0] — 2026-08-08

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
