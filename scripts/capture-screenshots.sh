#!/usr/bin/env bash
# Capture assets/screenshots/<theme>.png — one prompt shot per theme.
#
# OPTIONAL convenience. Previews may equally be taken by hand; the only
# requirements are a 1400x260 PNG named after the theme. Prefer passing the
# theme you changed so the rest of the gallery keeps its original author's
# OS icon — the variety is deliberate.
#
# Requires vhs (https://github.com/charmbracelet/vhs) and a Nerd Font.
# Everything renders inside a throwaway sandbox: your ~/.zshrc, ~/.p10k.zsh,
# and ~/.config/df-p10k-themes are never read or written.
#
#   scripts/capture-screenshots.sh              # every theme, default accent
#   scripts/capture-screenshots.sh tokyo-night  # one theme
#
# Overridable: DF_P10K_SHOT_FONT, DF_P10K_SHOT_FONT_SIZE, DF_P10K_SHOT_WIDTH,
# DF_P10K_SHOT_HEIGHT, DF_P10K_SHOT_BG, POWERLEVEL9K_DIR.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
THEMES_DIR="$REPO_ROOT/themes"
OUT_DIR="$REPO_ROOT/assets/screenshots"

FONT="${DF_P10K_SHOT_FONT:-JetBrainsMono Nerd Font}"
FONT_SIZE="${DF_P10K_SHOT_FONT_SIZE:-20}"
WIDTH="${DF_P10K_SHOT_WIDTH:-1400}"
HEIGHT="${DF_P10K_SHOT_HEIGHT:-260}"

die() { printf '\033[31m✗\033[0m %s\n' "$*" >&2; exit 1; }
info() { printf '\033[32m✓\033[0m %s\n' "$*"; }

command -v vhs >/dev/null 2>&1 \
  || die 'vhs not found — see https://github.com/charmbracelet/vhs#installation'
command -v zsh >/dev/null 2>&1 || die 'zsh not found'
# build_sandbox stands up a throwaway repo with staged, unstaged and
# untracked work so the vcs segment has something to render.
command -v git >/dev/null 2>&1 || die 'git not found'
# vhs already depends on ffmpeg, but we call it directly (see capture below).
command -v ffmpeg >/dev/null 2>&1 || die 'ffmpeg not found'

#---------- locate powerlevel10k ----------

find_p10k() {
  local dir
  for dir in \
    "${POWERLEVEL9K_DIR:-}" \
    "$HOME/.local/share/zinit/plugins/romkatv---powerlevel10k" \
    "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" \
    "$HOME/powerlevel10k" \
    "$HOME/.zsh/powerlevel10k" \
    /usr/share/zsh-theme-powerlevel10k \
    /usr/local/opt/powerlevel10k/share/powerlevel10k \
    /opt/homebrew/opt/powerlevel10k/share/powerlevel10k
  do
    if [[ -n "$dir" && -f "$dir/powerlevel10k.zsh-theme" ]]; then
      printf '%s' "$dir"
      return 0
    fi
  done
  return 1
}

P10K_DIR="$(find_p10k)" \
  || die 'powerlevel10k not found — set POWERLEVEL9K_DIR to its checkout'
[[ -f "$P10K_DIR/config/p10k-lean.zsh" ]] \
  || die "p10k lean preset missing in $P10K_DIR/config"

#---------- theme metadata ----------

# Read the palette straight out of the theme file. Sourcing is safe: theme
# files only assign variables.
theme_colors() {
  zsh -f -c '
    source "$1" || exit 1
    print -r -- "$c_subtext" "$c_muted" "$c_red" "$c_green" \
                "$c_yellow" "$c_blue" "$c_mauve" "$c_cyan" "$c_subtext"
  ' df-p10k-shot "$1"
}

# Backdrop for the gallery only. Themes deliberately declare no background:
# df-p10k-themes never touches yours, and a palette has no business deciding
# what your terminal looks like. But a screenshot needs *some* canvas, and
# the light themes are unreadable on a dark one — so the value lives here,
# next to the only code that needs it.
shot_background() {
  case "$1" in
    catppuccin-mocha)     printf '#1e1e2e' ;;
    catppuccin-macchiato) printf '#24273a' ;;
    catppuccin-frappe)    printf '#303446' ;;
    catppuccin-latte)     printf '#eff1f5' ;;
    tokyo-night)          printf '#1a1b26' ;;
    one-dark-pro)         printf '#282c34' ;;
    gruvbox-dark)         printf '#282828' ;;
    nord)                 printf '#2e3440' ;;
    dracula)              printf '#282a36' ;;
    rose-pine)            printf '#191724' ;;
    rose-pine-dawn)       printf '#faf4ed' ;;
    kanagawa)             printf '#1f1f28' ;;
    everforest-dark)      printf '#2d353b' ;;
    solarized-dark)       printf '#002b36' ;;
    solarized-light)      printf '#fdf6e3' ;;
    *)                    printf '%s' "${DF_P10K_SHOT_BG:-#1e1e2e}" ;;
  esac
}

# VHS wants the full 16-color set. P10k emits truecolor escapes directly, so
# only background/foreground really show — the rest keeps command output
# (ls, git) in the same family instead of falling back to terminal defaults.
theme_json() {
  local bg=$1 fg=$2 black=$3 red=$4 green=$5 yellow=$6 blue=$7 magenta=$8 cyan=$9 white=${10}
  printf '{ "background": "%s", "foreground": "%s", "cursor": "%s", "selection": "%s"' \
    "$bg" "$fg" "$fg" "$black"
  printf ', "black": "%s", "red": "%s", "green": "%s", "yellow": "%s"' \
    "$black" "$red" "$green" "$yellow"
  printf ', "blue": "%s", "magenta": "%s", "cyan": "%s", "white": "%s"' \
    "$blue" "$magenta" "$cyan" "$white"
  printf ', "brightBlack": "%s", "brightRed": "%s", "brightGreen": "%s", "brightYellow": "%s"' \
    "$black" "$red" "$green" "$yellow"
  printf ', "brightBlue": "%s", "brightMagenta": "%s", "brightCyan": "%s", "brightWhite": "%s" }' \
    "$blue" "$magenta" "$cyan" "$white"
}

#---------- sandbox ----------

SANDBOX="$(mktemp -d)"
# Staged beside the gallery, not in the sandbox, so the final swap is a
# same-directory rename. Pid-keyed so two terminals capturing different
# themes cannot trample each other's frame, and the suffix must stay off
# .png — the gallery test globs *.png and would read a stray staging
# frame as a preview belonging to no theme.
STAGE="$OUT_DIR/.capture.$$.part"
trap 'rm -rf "$SANDBOX"; rm -f "$STAGE"' EXIT

build_sandbox() {
  mkdir -p "$SANDBOX/.config" "$SANDBOX/demo"

  # A repo with staged, unstaged, and untracked work so the vcs segment has
  # something to say.
  git init -q -b main "$SANDBOX/demo/df-p10k-themes"
  (
    cd "$SANDBOX/demo/df-p10k-themes"
    printf 'tracked\n' >tracked.zsh
    git add tracked.zsh
    git -c user.email=demo@example.com -c user.name=demo commit -q -m 'initial'
    printf 'modified\n' >>tracked.zsh   # unstaged  -> !1
    printf 'staged\n' >staged.zsh
    git add staged.zsh                  # staged    -> +1
    printf 'untracked\n' >untracked.zsh # untracked -> ?1
  )

  cat >"$SANDBOX/.zshrc" <<EOF
export LANG=en_US.UTF-8
export PATH="$REPO_ROOT/bin:\$PATH"
export DF_P10K_THEMES_DIR="$THEMES_DIR"
export DF_P10K_THEMES_ZSHRC="$SANDBOX/.zshrc"
export XDG_CONFIG_HOME="$SANDBOX/.config"

# P10k's own lean preset — the shots show what a real user sees, not a
# prompt layout invented by this script.
source "$P10K_DIR/powerlevel10k.zsh-theme"
source "$P10K_DIR/config/p10k-lean.zsh"

# The lean preset ships os_icon and time commented out. The gallery exists to
# show the palette, and without these the os icon is missing and the right
# prompt renders empty — so put both back.
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon \$POWERLEVEL9K_LEFT_PROMPT_ELEMENTS)
typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(\$POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS time)
typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
typeset -g POWERLEVEL9K_DISABLE_HOT_RELOAD=true

# The capture is the last frame of a recording, so a blinking cursor lands
# on or off at random and the gallery ends up inconsistent. vhs 0.11 has no
# cursor setting, so hide it (DECTCEM) before every prompt.
precmd_functions+=(_df_shot_hide_cursor)
_df_shot_hide_cursor() { printf '\\e[?25l' }
EOF

  DF_P10K_THEMES_ZSHRC="$SANDBOX/.zshrc" \
  XDG_CONFIG_HOME="$SANDBOX/.config" \
  DF_P10K_THEMES_DIR="$THEMES_DIR" \
    "$REPO_ROOT/bin/df-p10k-themes" init >/dev/null
}

#---------- capture ----------

capture() {
  local theme="$1"
  local theme_file="$THEMES_DIR/$theme.zsh"
  local out="$OUT_DIR/$theme.png"
  local -a colors
  read -r -a colors < <(theme_colors "$theme_file") \
    || die "cannot read palette from $theme_file"
  (( ${#colors[@]} == 9 )) || die "$theme: incomplete palette metadata"
  colors=("$(shot_background "$theme")" "${colors[@]}")

  DF_P10K_THEMES_ZSHRC="$SANDBOX/.zshrc" \
  XDG_CONFIG_HOME="$SANDBOX/.config" \
  DF_P10K_THEMES_DIR="$THEMES_DIR" \
    "$REPO_ROOT/bin/df-p10k-themes" apply "$theme" >/dev/null

  # Two vhs quirks drive the shape of this tape:
  #   - the parser chokes on unquoted absolute paths, hence the quoting;
  #   - `Set Shell zsh` starts zsh with --no-rcs, so .zshrc is never read and
  #     p10k never loads. `exec zsh` replaces it with an interactive shell
  #     that does read it.
  cat >"$SANDBOX/shot.tape" <<EOF
Output "$SANDBOX/shot.gif"
Set Shell zsh
Set FontFamily "$FONT"
Set FontSize $FONT_SIZE
Set Width $WIDTH
Set Height $HEIGHT
Set Padding 24
Set Theme $(theme_json "${colors[@]}")

Hide
Type "exec zsh" Enter
Sleep 3s
Type "cd ~/demo/df-p10k-themes" Enter
Sleep 3s
Ctrl+L
Show
Type "df-p10k-themes current" Enter
Sleep 3s
EOF

  rm -f "$SANDBOX/shot.gif"
  ZDOTDIR="$SANDBOX" HOME="$SANDBOX" vhs "$SANDBOX/shot.tape" >/dev/null
  [[ -f "$SANDBOX/shot.gif" ]] || die "$theme: vhs produced no recording"

  # vhs 0.11's `Screenshot` directive parses and exits 0 but never writes the
  # file, so pull the frame out of the recording instead. `-update 1` keeps
  # overwriting the same PNG, leaving the last frame — the settled prompt.
  # ffmpeg truncates its output the moment it opens it, so never point it at
  # a committed preview: a capture that dies mid-encode would leave the
  # gallery holding a corpse. Extract, check, then rename into place.
  ffmpeg -y -loglevel error -i "$SANDBOX/shot.gif" -update 1 "$SANDBOX/shot.png"
  [[ -s "$SANDBOX/shot.png" ]] || die "$theme: could not extract a frame"
  cp "$SANDBOX/shot.png" "$STAGE"
  mv -f "$STAGE" "$out"
  info "$theme → ${out#"$REPO_ROOT"/}"
}

#---------- main ----------

mkdir -p "$OUT_DIR"
build_sandbox

if (( $# > 0 )); then
  themes=("$@")
else
  themes=()
  for f in "$THEMES_DIR"/*.zsh; do
    name="$(basename "$f" .zsh)"
    [[ "$name" == _* ]] && continue
    themes+=("$name")
  done
fi

for theme in "${themes[@]}"; do
  [[ -f "$THEMES_DIR/$theme.zsh" ]] || die "unknown theme: $theme"
  capture "$theme"
done
