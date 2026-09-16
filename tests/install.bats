#!/usr/bin/env bats

load 'test_helper'

setup() {
  setup_sandbox
  unset DF_P10K_THEMES_DIR
  export XDG_DATA_HOME="$SANDBOX/xdg-data"
  PREFIX="$SANDBOX/custom-prefix"
  make -C "$REPO_ROOT" install PREFIX="$PREFIX" >/dev/null
  INSTALLED_CLI="$PREFIX/bin/df-p10k-themes"
}

@test "a custom PREFIX install prefers colocated themes over stale XDG data" {
  mkdir -p "$XDG_DATA_HOME/df-p10k-themes/themes"
  printf '# stale XDG theme\n' >"$XDG_DATA_HOME/df-p10k-themes/themes/stale-only.zsh"

  run "$INSTALLED_CLI" list
  [ "$status" -eq 0 ]
  [[ "$output" == *"catppuccin-mocha"* ]]
  [[ "$output" == *"tokyo-night"* ]]
  [[ "$output" != *"stale-only"* ]]

  "$INSTALLED_CLI" init >/dev/null
  run "$INSTALLED_CLI" apply tokyo-night
  [ "$status" -eq 0 ]
  [ -f "$(active_file)" ]

  run "$INSTALLED_CLI" current
  [ "$status" -eq 0 ]
  [ "$output" = "tokyo-night (accent: blue)" ]
}

@test "a symlinked installed executable works when readlink has no -f option" {
  mkdir -p "$SANDBOX/linked-bin" "$SANDBOX/run" "$SANDBOX/fake-bin"
  ln -s ../custom-prefix/bin/df-p10k-themes "$SANDBOX/linked-bin/df-p10k-themes"
  cat >"$SANDBOX/fake-bin/readlink" <<'EOF'
#!/bin/sh
if [ "${1-}" = '-f' ]; then
  exit 64
fi
exec /usr/bin/readlink "$@"
EOF
  chmod 0755 "$SANDBOX/fake-bin/readlink"
  export PATH="$SANDBOX/fake-bin:$PATH"

  run bash -c 'cd "$1" && exec "$2" list' _ "$SANDBOX/run" "$SANDBOX/linked-bin/df-p10k-themes"

  [ "$status" -eq 0 ]
  [[ "$output" == *"catppuccin-mocha"* ]]
  [[ "$output" == *"tokyo-night"* ]]
}

# Shadow curl with a stub that serves a GitHub-shaped tarball of this checkout
# (top-level dir, like archive/refs/heads/main.tar.gz) and records the call.
fake_curl_tarball() {
  mkdir -p "$SANDBOX/tarball/df-p10k-themes-main" "$SANDBOX/fake-bin"
  cp -R "$REPO_ROOT/Makefile" "$REPO_ROOT/bin" "$REPO_ROOT/themes" \
    "$SANDBOX/tarball/df-p10k-themes-main/"
  tar -czf "$SANDBOX/main.tar.gz" -C "$SANDBOX/tarball" df-p10k-themes-main
  cat >"$SANDBOX/fake-bin/curl" <<EOS
#!/bin/sh
printf '%s\n' "\$*" >>"$SANDBOX/curl.calls"
exec cat "$SANDBOX/main.tar.gz"
EOS
  chmod 0755 "$SANDBOX/fake-bin/curl"
  export PATH="$SANDBOX/fake-bin:$PATH"
}

@test "a piped install fetches the tarball and never runs a Makefile from the cwd" {
  fake_curl_tarball
  mkdir -p "$SANDBOX/hostile/bin" "$SANDBOX/tmp"
  printf 'decoy\n' >"$SANDBOX/hostile/bin/df-p10k-themes"
  printf 'install:\n\ttouch "%s/pwned"\n' "$SANDBOX" >"$SANDBOX/hostile/Makefile"
  export TMPDIR="$SANDBOX/tmp"
  PREFIX="$SANDBOX/piped-prefix"

  run bash -c 'cd "$1" && PREFIX="$2" bash <"$3"' _ \
    "$SANDBOX/hostile" "$PREFIX" "$REPO_ROOT/install.sh"

  [ "$status" -eq 0 ]
  [ ! -e "$SANDBOX/pwned" ]
  assert_file_contains "$SANDBOX/curl.calls" \
    "https://github.com/bladhl/df-p10k-themes/archive/refs/heads/main.tar.gz"
  cmp -s "$PREFIX/bin/df-p10k-themes" "$CLI"
  [ -f "$PREFIX/share/df-p10k-themes/themes/catppuccin-mocha.zsh" ]
  [ -z "$(ls -A "$TMPDIR")" ]
}

@test "a checkout install uses the local tree without downloading" {
  fake_curl_tarball
  PREFIX="$SANDBOX/checkout-prefix"

  run env PREFIX="$PREFIX" "$REPO_ROOT/install.sh"

  [ "$status" -eq 0 ]
  [ ! -e "$SANDBOX/curl.calls" ]
  cmp -s "$PREFIX/bin/df-p10k-themes" "$CLI"
}
