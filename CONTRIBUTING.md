# Contributing

Thanks for helping out. This project is small on purpose: a CLI in
`bin/df-p10k-themes`, one file per theme in `themes/`, and a shared binding
layer in `themes/_bindings.zsh`.

## Before you start

```sh
make test     # bats specs
make lint     # shellcheck on the shell sources
make syntax   # zsh -n on every theme file
```

All three run in CI on Linux and macOS. A PR that does not pass them locally
will not pass there either.

Tooling:

```sh
# Arch / Manjaro
sudo pacman -S bash-bats shellcheck

# Debian / Ubuntu
sudo apt-get install bats shellcheck

# macOS
brew install bats-core shellcheck
```

## Adding a theme

1. Copy `themes/_template.zsh` to `themes/<your-theme>.zsh`.
2. Fill in `THEME_PALETTE`, `THEME_ACCENTS`, `THEME_ACCENT_DEFAULT`, and the
   `c_*` role globals. The template documents the full contract.
3. Run `make syntax` and `make test`.
4. Add the theme to the table in `README.md` and to the `Unreleased` section
   of `CHANGELOG.md`.
5. Optionally add a preview — see below.
6. Open a PR.

A theme file declares **palette and semantic roles only**. Every
`POWERLEVEL9K_*` assignment and the `my_git_formatter` redefinition live in
`themes/_bindings.zsh`, so a theme never needs to know which prompt segment
uses which color. If your palette is smaller than the role list, map several
roles to the same value — see `themes/nord.zsh`.

## Previews (optional)

A preview is welcome but never required. A good theme with no screenshot beats
no theme at all — send the palette and we'll sort the picture out.

If you do add one, only three things are enforced (CI checks them):

- **PNG**, exactly **1400 × 260**
- named **`assets/screenshots/<theme>.png`**
- the theme on its **default accent**

The easy route needs [vhs](https://github.com/charmbracelet/vhs) and captures
just your theme, leaving the rest of the gallery alone:

```sh
make screenshots THEME=<your-theme>     # one theme
make screenshots                        # everything, rarely what you want
```

Taking it by hand is equally fine as long as it matches the three rules above.
To blend in with the rest of the gallery: p10k's `lean` preset, a Nerd Font at
20px, 24px padding, and a repo with one staged, one modified, and one
untracked file so the vcs segment shows `+1 !1 ?1`.

**Your own OS icon is a feature, not a mismatch.** If you capture on Ubuntu,
macOS, or Fedora, the icon shows your system's color and that is exactly what
the gallery should look like. Do not fake someone else's distro.

## How the OS icon gets its color

Powerlevel10k picks the right glyph for your system, but paints every one of
them white — and it never exposes *which* distribution it detected, only the
glyph. So `themes/_bindings.zsh` works it out again: it reads the `ID=` line
your distro already ships in `/etc/os-release` and looks that name up in
`_DF_P10K_OS_COLOR`.

That system file is **read, never written** — nothing here modifies anything
outside your own config, same as the CLI never touches `~/.p10k.zsh`.

An unmapped system is **not a bug**: it falls back to the theme accent and the
prompt still looks right. The map only exists because a brand color cannot be
computed — there is no formula from `ubuntu` to orange, so somebody has to
write it down once.

To give a distribution its brand hue, add one line to `_DF_P10K_OS_COLOR` in
`themes/_bindings.zsh`, pointing at the closest `c_*` role. Compound IDs like
`opensuse-leap` fall back to the part before the dash, so `opensuse` covers
the whole family.

## Changing the CLI

`bin/df-p10k-themes` is POSIX-ish bash with `set -euo pipefail`. Two rules
carry the whole design:

- **Never write to `~/.p10k.zsh`.** The tool is additive; it owns
  `active.zsh` and one marker block in `~/.zshrc`, nothing else.
- **Every write is atomic.** Render to a temp file next to the target, verify,
  then `mv`. See `begin_atomic_write` / `commit_atomic_write`.

Behavior changes need a spec in `tests/`. The existing suite covers the
marker lifecycle, backup and restore semantics, symlinked targets, and
partial-failure recovery — keep that level of coverage.

## Commits and PRs

Conventional Commits (`feat:`, `fix:`, `docs:`, `test:`, `chore:`). Keep the
PR focused on one change and describe what a user would notice.
