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

@test "every theme resolves an os icon color for this host" {
  df_cli init >/dev/null
  local name theme
  while IFS= read -r name; do
    theme="${name%.zsh}"
    df_cli apply "$theme" >/dev/null || { echo "apply failed: $theme" >&2; return 1; }
    run zsh -f -c 'source "$1" || exit 1; print -r -- "$POWERLEVEL9K_OS_ICON_FOREGROUND"' \
      df-p10k-themes "$(active_file)"
    [ "$status" -eq 0 ] || { echo "sourcing failed for $theme: $output" >&2; return 1; }
    [ -n "$output" ] || { echo "$theme: empty POWERLEVEL9K_OS_ICON_FOREGROUND" >&2; return 1; }
  done < <(theme_files)
}

# The test above only ever exercises whichever branch this host happens to
# take, and the fallback guarantees a non-empty answer — so it passes even
# if the mapping is wrong. Pin the branches against fixtures instead, where
# a wrong color is detectably a wrong color.
@test "os icon colors follow the id, the family, then the accent" {
  [[ "$(uname -s)" == Linux ]] || skip "os-release detection only runs on Linux"
  df_cli init >/dev/null
  df_cli apply dracula >/dev/null || { echo "apply failed: dracula" >&2; return 1; }

  # RHEL-family and openSUSE hosts quote the value in their shipped
  # /etc/os-release, so both spellings have to land on the same color.
  local fixture="$SANDBOX/os-release" case_ line expected
  for case_ in \
    'ID=ubuntu:c_peach' \
    'ID=ubuntu\r:c_peach' \
    'ID="rhel":c_red' \
    'ID=opensuse-leap:c_green' \
    'ID="opensuse-leap":c_green' \
    'ID=notadistro:c_accent'
  do
    line="${case_%:*}"
    expected="${case_##*:}"
    printf '%b\n' "$line" >"$fixture"
    run env _DF_P10K_OS_RELEASE="$fixture" zsh -f -c '
      source "$1" || exit 1
      [[ $POWERLEVEL9K_OS_ICON_FOREGROUND == ${(P)2} ]] \
        || { print -r -- "got $POWERLEVEL9K_OS_ICON_FOREGROUND, want $2=${(P)2}"; exit 1 }
    ' df-p10k-themes "$(active_file)" "$expected"
    [ "$status" -eq 0 ] || { echo "$line: $output" >&2; return 1; }
  done

  # An unreadable os-release must degrade to the accent, not to empty. The
  # seam cannot mask /etc/artix-release, so on Artix expect that branch.
  local want=c_accent
  [[ -e /etc/artix-release ]] && want=c_cyan
  run env _DF_P10K_OS_RELEASE="$SANDBOX/absent" zsh -f -c '
    source "$1" || exit 1
    [[ $POWERLEVEL9K_OS_ICON_FOREGROUND == ${(P)2} ]] \
      || { print -r -- "got $POWERLEVEL9K_OS_ICON_FOREGROUND, want $2=${(P)2}"; exit 1 }
  ' df-p10k-themes "$(active_file)" "$want"
  [ "$status" -eq 0 ] || { echo "missing os-release: $output" >&2; return 1; }
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
