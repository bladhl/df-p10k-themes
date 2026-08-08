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
