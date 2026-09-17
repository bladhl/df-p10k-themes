#!/usr/bin/env bats
#
# WCAG 2.x contrast checks for every shipped theme in every prompt style
# (lean, classic, rainbow). See tests/fixtures/wcag_contrast.zsh for the
# independent contrast math and the fg/bg pairing rule.

load 'test_helper'

setup() { setup_sandbox; df_cli init >/dev/null; }

WCAG_CHECK="$FIXTURES/wcag_contrast.zsh"

theme_files() {
  local path name
  for path in "$THEMES_DIR"/*.zsh; do
    name="${path##*/}"
    [[ "$name" == _* ]] || printf '%s\n' "$name"
  done | sort
}

@test "contrast math sanity-checks against known WCAG ratios" {
  run zsh -f "$WCAG_CHECK"
  [ "$status" -eq 0 ]
  [[ "$output" != *"SANITY FAIL"* ]]
}

@test "every theme meets its WCAG contrast threshold in lean, classic and rainbow" {
  local name theme af style total=0 failures='' out n
  while IFS= read -r name; do
    theme="${name%.zsh}"
    df_cli apply "$theme" >/dev/null
    af="$(active_file)"
    for style in lean classic rainbow; do
      case $style in
        lean)    out="$(zsh -f "$WCAG_CHECK" "$af" "$theme" "$style" || true)" ;;
        classic) out="$(POWERLEVEL9K_BACKGROUND=238 zsh -f "$WCAG_CHECK" "$af" "$theme" "$style" || true)" ;;
        rainbow) out="$(POWERLEVEL9K_DIR_BACKGROUND=4 zsh -f "$WCAG_CHECK" "$af" "$theme" "$style" || true)" ;;
      esac
      n="${out##*CHECKS=}"
      n="${n%%$'\n'*}"
      total=$(( total + n ))
      local pairs
      pairs="$(printf '%s\n' "$out" | grep -v '^CHECKS=' || true)"
      [[ -n "$pairs" ]] && failures+="$pairs"$'\n'
    done
  done < <(theme_files)

  # >&3 is bats' always-shown diagnostic channel — printed whether this test
  # passes or fails, so the check count stays verifiable either way.
  echo "checks performed: $total" >&3
  if [[ -n "$failures" ]]; then
    printf '%s' "$failures"
    return 1
  fi
}
