#!/usr/bin/env bats

load 'test_helper'

setup() { setup_sandbox; df_cli init >/dev/null; }

@test "apply writes active.zsh with header metadata" {
  run df_cli apply catppuccin-mocha
  [ "$status" -eq 0 ]
  local af; af="$(active_file)"
  [ -f "$af" ]
  assert_file_contains "$af" "theme=catppuccin-mocha"
  assert_file_contains "$af" "accent=mauve"
  assert_file_contains "$af" "POWERLEVEL9K_DIR_FOREGROUND"
  assert_file_contains "$af" "my_git_formatter"
}

@test "apply creates a new active file with mode 0600" {
  umask 000
  df_cli apply catppuccin-mocha >/dev/null
  [ "$(file_mode "$(active_file)")" = 600 ]
}

@test "apply with accent appends overlay" {
  run df_cli apply catppuccin-mocha peach
  [ "$status" -eq 0 ]
  local af; af="$(active_file)"
  assert_file_contains "$af" "accent=peach"
  assert_file_contains "$af" "set_accent peach"
}

@test "apply rejects unknown theme with exit 2" {
  run df_cli apply does-not-exist
  [ "$status" -eq 2 ]
  [[ "$output" == *"unknown theme"* ]]
}

@test "apply rejects unknown accent with exit 2 and lists valid ones" {
  run df_cli apply catppuccin-mocha NOTACOLOR
  [ "$status" -eq 2 ]
  [[ "$output" == *"unknown accent"* ]]
  [[ "$output" == *"available:"* ]]
  [[ "$output" == *"mauve"* ]]
}

@test "apply emits zsh-valid active.zsh" {
  df_cli apply tokyo-night blue >/dev/null
  zsh -n "$(active_file)"
}

@test "current reports the applied theme + accent" {
  df_cli apply gruvbox-dark yellow >/dev/null
  run df_cli current
  [ "$status" -eq 0 ]
  [ "$output" = "gruvbox-dark (accent: yellow)" ]
}

@test "current reports the resolved default accent" {
  df_cli apply catppuccin-mocha >/dev/null
  run df_cli current
  [ "$status" -eq 0 ]
  [ "$output" = "catppuccin-mocha (accent: mauve)" ]
}

@test "applying again replaces active.zsh atomically" {
  df_cli apply catppuccin-mocha >/dev/null
  df_cli apply nord >/dev/null
  local af; af="$(active_file)"
  assert_file_contains "$af" "theme=nord"
  assert_file_missing_text "$af" "theme=catppuccin-mocha"
}

@test "invalid rendered or sourced zsh never replaces a valid active file" {
  cp -R "$THEMES_DIR" "$SANDBOX/test-themes"
  export DF_P10K_THEMES_DIR="$SANDBOX/test-themes"
  df_cli apply nord >/dev/null
  local expected_hash
  expected_hash="$(file_hash "$(active_file)")"
  printf '\nif true; then\n' >>"$DF_P10K_THEMES_DIR/_bindings.zsh"

  run df_cli apply tokyo-night

  [ "$status" -ne 0 ]
  [ "$expected_hash" = "$(file_hash "$(active_file)")" ]
  assert_no_active_temps

  cp "$THEMES_DIR/_bindings.zsh" "$DF_P10K_THEMES_DIR/_bindings.zsh"
  printf '\nreturn 1\n' >>"$DF_P10K_THEMES_DIR/_bindings.zsh"
  run df_cli apply tokyo-night

  [ "$status" -ne 0 ]
  [ "$expected_hash" = "$(file_hash "$(active_file)")" ]
  assert_no_active_temps
}

@test "producer failure never replaces a valid active file or leaves a candidate" {
  cp -R "$THEMES_DIR" "$SANDBOX/test-themes"
  export DF_P10K_THEMES_DIR="$SANDBOX/test-themes"
  df_cli apply nord >/dev/null
  local expected_hash
  expected_hash="$(file_hash "$(active_file)")"
  mkdir -p "$SANDBOX/fake-bin"
  cat >"$SANDBOX/fake-bin/cat" <<'EOF'
#!/bin/sh
case "${1-}" in
  */_bindings.zsh) printf '# partial binding\n'; exit 1 ;;
  *) exec /bin/cat "$@" ;;
esac
EOF
  chmod 0755 "$SANDBOX/fake-bin/cat"
  export PATH="$SANDBOX/fake-bin:$PATH"

  run df_cli apply tokyo-night

  [ "$status" -ne 0 ]
  [ "$expected_hash" = "$(file_hash "$(active_file)")" ]
  assert_no_active_temps
}
