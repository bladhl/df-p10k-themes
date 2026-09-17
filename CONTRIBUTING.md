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
   `c_*` role globals. The template documents the full contract, including
   three surface roles used by the `classic`/`rainbow` prompt styles (see
   "Prompt styles" in the README):
   - `c_base` — the palette's own page/terminal background.
   - `c_surface` — the shared segment background for `classic` style. Pick
     whichever step gives text the best contrast: the darkest neutral on a
     dark theme, the lightest on a light one, distinct from `c_base` where
     the palette has one (many palettes call this "crust"/"mantle" on dark
     variants). Reuse `c_base` only if the upstream palette truly has
     nothing else.
   - `c_text` — primary on-surface text color, used by the `rainbow` style's
     contrast picker (`_df_p10k_on_color` in `_bindings.zsh`).

   `c_base`/`c_surface`/`c_text` must be `#rrggbb` hex — the WCAG contrast
   math only understands that format.
3. Run `make syntax` and `make test` (`make test` includes
   `tests/contrast.bats`, which checks WCAG contrast for every role against
   `c_base`/`c_surface` in all three prompt styles). The bar is **4.5:1**
   only for `c_text` sitting directly on `c_base`/`c_surface` (that's the one
   pair shaped like reading text); everything else — every chromatic hue,
   `c_muted`, `c_subtext`, and a rainbow segment's on-color foreground
   against its own hue background — needs **3.0:1** (WCAG 1.4.11, the
   non-text/UI floor: prompt segments are short bold color chips, not body
   text). This suite must stay green; a failing role is not an acceptable
   partial.
   If a role fails, first prefer a different *already-shipped* step of the
   same upstream palette (e.g. `overlay1` instead of `overlay0`, or letting
   `c_surface` reuse `c_base` when the palette has nothing darker/lighter to
   move to). If no shipped step clears the bar, retune the color itself by
   the minimal HSL lightness change needed to reach 3.0:1 against every
   background it's paired with — keep the hue and saturation untouched so it
   still reads as the same color — and comment the change inline:
   `# adjusted from #oldhex (X.XX:1 on base) → 3.0:1`. Never loosen the test
   and never invent an unrelated color.
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
