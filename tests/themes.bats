#!/usr/bin/env bats

load 'test_helper'

setup() { setup_sandbox; }

theme_files() {
  local path name
  for path in "$THEMES_DIR"/*.zsh; do
    name="${path##*/}"
    [[ "$name" == _* ]] || printf '%s\n' "$name"
  done | sort
}

@test "every shipped theme passes zsh -n" {
  local f
  for f in "$THEMES_DIR"/*.zsh; do
    zsh -n "$f" || { echo "syntax FAIL: $f" >&2; return 1; }
  done
}

@test "every theme declares THEME_PALETTE, THEME_ACCENTS, THEME_ACCENT_DEFAULT" {
  local name
  while IFS= read -r name; do
    local path="$THEMES_DIR/$name"
    grep -q '^typeset -gA THEME_PALETTE=' "$path" || { echo "$name: missing THEME_PALETTE" >&2; return 1; }
    grep -q '^THEME_ACCENTS=' "$path" || { echo "$name: missing THEME_ACCENTS" >&2; return 1; }
    grep -q '^THEME_ACCENT_DEFAULT=' "$path" || { echo "$name: missing THEME_ACCENT_DEFAULT" >&2; return 1; }
  done < <(theme_files)
}

@test "every theme declares the required role globals" {
  local name role
  local roles=(c_accent c_ok c_warn c_error c_info c_muted c_subtext
               c_red c_ruby c_peach c_yellow c_green c_teal c_cyan
               c_sky c_sapphire c_blue c_lavender c_mauve c_purple c_pink)
  while IFS= read -r name; do
    local path="$THEMES_DIR/$name"
    for role in "${roles[@]}"; do
      grep -q "^typeset -g $role=" "$path" || { echo "$name: missing $role" >&2; return 1; }
    done
  done < <(theme_files)
}

@test "applying every theme produces a zsh-valid active.zsh" {
  df_cli init >/dev/null
  local name theme
  while IFS= read -r name; do
    theme="${name%.zsh}"
    df_cli apply "$theme" >/dev/null || { echo "apply failed: $theme" >&2; return 1; }
    zsh -n "$(active_file)" || { echo "active.zsh invalid for: $theme" >&2; return 1; }
  done < <(theme_files)
}

@test "the default accent of every theme is a valid accent override" {
  df_cli init >/dev/null
  local name theme default
  while IFS= read -r name; do
    theme="${name%.zsh}"
    default="$(awk -F'=' '/^THEME_ACCENT_DEFAULT=/ {gsub(/[" '\''\t]/,"",$2); print $2; exit}' "$THEMES_DIR/$name")"
    run df_cli apply "$theme" "$default"
    [ "$status" -eq 0 ] || { echo "default accent rejected for $theme: $default" >&2; return 1; }
  done < <(theme_files)
}
