#!/usr/bin/env bats

load 'test_helper'

setup() { setup_sandbox; }

@test "help prints usage" {
  run df_cli --help
  [ "$status" -eq 0 ]
  [[ "$output" == *"USAGE"* ]]
  [[ "$output" == *"df-p10k-themes init"* ]]
}

@test "version prints semver" {
  run df_cli --version
  [ "$status" -eq 0 ]
  [[ "$output" =~ df-p10k-themes\ [0-9]+\.[0-9]+\.[0-9]+ ]]
}

@test "list enumerates shipped themes alphabetically and skips _-prefixed" {
  run df_cli list
  [ "$status" -eq 0 ]
  [[ "$output" == *"catppuccin-frappe"* ]]
  [[ "$output" == *"catppuccin-mocha"* ]]
  [[ "$output" == *"tokyo-night"* ]]
  [[ "$output" != *"_bindings"* ]]
  [[ "$output" != *"_template"* ]]
  # Alphabetical: frappe before macchiato before mocha
  local frappe_pos macchiato_pos mocha_pos
  frappe_pos=$(echo "$output" | grep -n catppuccin-frappe | head -1 | cut -d: -f1)
  macchiato_pos=$(echo "$output" | grep -n catppuccin-macchiato | head -1 | cut -d: -f1)
  mocha_pos=$(echo "$output" | grep -n catppuccin-mocha | head -1 | cut -d: -f1)
  [ "$frappe_pos" -lt "$macchiato_pos" ]
  [ "$macchiato_pos" -lt "$mocha_pos" ]
}

@test "list propagates sort failure without printing partial output" {
  mkdir -p "$SANDBOX/fake-bin"
  cat >"$SANDBOX/fake-bin/sort" <<'EOF'
#!/bin/sh
printf 'misleading partial output\n'
exit 88
EOF
  chmod 0755 "$SANDBOX/fake-bin/sort"
  export PATH="$SANDBOX/fake-bin:$PATH"

  run df_cli list

  [ "$status" -eq 88 ]
  [ -z "$output" ]
}

@test "accents prints palette colors for a theme" {
  run df_cli accents tokyo-night
  [ "$status" -eq 0 ]
  [[ "$output" == *"theme:   tokyo-night"* ]]
  [[ "$output" == *"default: blue"* ]]
  [[ "$output" == *"magenta"* ]]
}

@test "unknown subcommand exits 2 with help" {
  run df_cli wat
  [ "$status" -eq 2 ]
  [[ "$output" == *"unknown command or theme"* ]]
}

@test "bare theme name is treated as 'apply'" {
  df_cli init >/dev/null
  run df_cli catppuccin-mocha
  [ "$status" -eq 0 ]
  [ -f "$(active_file)" ]
}

@test "current reports no active theme when none applied" {
  run df_cli current
  [ "$status" -eq 0 ]
  [[ "$output" == *"no active theme"* ]]
}

@test "every command rejects surplus arguments before mutation" {
  df_cli init >/dev/null
  df_cli apply nord >/dev/null
  local zshrc_hash active_hash invocation
  zshrc_hash="$(file_hash "$SANDBOX/.zshrc")"
  active_hash="$(file_hash "$(active_file)")"

  for invocation in \
    "help extra" \
    "version extra" \
    "init extra" \
    "apply tokyo-night blue extra" \
    "list extra" \
    "accents tokyo-night extra" \
    "current extra" \
    "uninstall extra" \
    "tokyo-night blue extra"; do
    run df_cli $invocation
    [ "$status" -eq 2 ] || {
      echo "expected surplus arguments to exit 2: $invocation" >&2
      return 1
    }
  done

  [ "$zshrc_hash" = "$(file_hash "$SANDBOX/.zshrc")" ]
  [ "$active_hash" = "$(file_hash "$(active_file)")" ]
}
