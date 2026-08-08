# shellcheck shell=bash
# Common helpers for df-p10k-themes bats specs.

REPO_ROOT="${REPO_ROOT:-$(cd "${BATS_TEST_DIRNAME}/.." && pwd)}"
THEMES_DIR="$REPO_ROOT/themes"
CLI="$REPO_ROOT/bin/df-p10k-themes"
FIXTURES="$REPO_ROOT/tests/fixtures"

setup_sandbox() {
  SANDBOX="$BATS_TEST_TMPDIR/sandbox"
  mkdir -p "$SANDBOX/.config"
  cp "$FIXTURES/zshrc.sample" "$SANDBOX/.zshrc"
  export HOME="$SANDBOX"
  export XDG_CONFIG_HOME="$SANDBOX/.config"
  export DF_P10K_THEMES_DIR="$THEMES_DIR"
  export DF_P10K_THEMES_ZSHRC="$SANDBOX/.zshrc"
}

df_cli() {
  "$CLI" "$@"
}

file_hash() {
  local output
  if command -v sha256sum >/dev/null 2>&1; then
    output="$(sha256sum "$1")"
  elif command -v shasum >/dev/null 2>&1; then
    output="$(shasum -a 256 "$1")"
  else
    printf 'no SHA-256 tool available\n' >&2
    return 1
  fi
  printf '%s\n' "${output%% *}"
}

file_mode() {
  local mode
  if mode="$(stat -c '%a' "$1" 2>/dev/null)"; then
    printf '%s\n' "$mode"
  elif mode="$(stat -f '%Lp' "$1" 2>/dev/null)"; then
    printf '%s\n' "$mode"
  else
    printf 'cannot read file mode: %s\n' "$1" >&2
    return 1
  fi
}

assert_file_contains() {
  local file="$1" needle="$2"
  if ! grep -qF "$needle" "$file"; then
    echo "expected '$needle' in $file" >&2
    echo "--- file content ---" >&2
    cat "$file" >&2
    return 1
  fi
}

assert_file_missing_text() {
  local file="$1" needle="$2"
  if grep -qF "$needle" "$file"; then
    echo "did not expect '$needle' in $file" >&2
    return 1
  fi
}

active_file() {
  printf '%s/df-p10k-themes/active.zsh' "$XDG_CONFIG_HOME"
}

assert_no_active_temps() {
  assert_no_file_temps "$(active_file)"
}

assert_no_file_temps() {
  local file="$1"
  local candidate
  for candidate in "$file".?????? "$file".source.??????; do
    if [[ -e "$candidate" || -L "$candidate" ]]; then
      printf 'unexpected atomic candidate: %s\n' "$candidate" >&2
      return 1
    fi
  done
}
