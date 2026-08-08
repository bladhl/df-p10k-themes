#!/usr/bin/env bats

load 'test_helper'

setup() { setup_sandbox; }

@test "init writes marker block and backup" {
  run df_cli init
  [ "$status" -eq 0 ]
  assert_file_contains "$SANDBOX/.zshrc" "# >>> df-p10k-themes >>>"
  assert_file_contains "$SANDBOX/.zshrc" "# <<< df-p10k-themes <<<"
  assert_file_contains "$SANDBOX/.zshrc" 'source "${XDG_CONFIG_HOME'
  [ -f "$SANDBOX/.zshrc.df-p10k-themes.bak" ]
}

@test "init is idempotent" {
  df_cli init >/dev/null
  local first_hash
  first_hash="$(file_hash "$SANDBOX/.zshrc")"
  run df_cli init
  [ "$status" -eq 0 ]
  [[ "$output" == *"already initialized"* ]]
  local second_hash
  second_hash="$(file_hash "$SANDBOX/.zshrc")"
  [ "$first_hash" = "$second_hash" ]
}

@test "init fails clearly when zshrc is missing" {
  rm "$SANDBOX/.zshrc"
  run df_cli init
  [ "$status" -ne 0 ]
  [[ "$output" == *"not found"* ]]
}

@test "init preserves a dangling backup symlink and destination" {
  chmod 0640 "$SANDBOX/.zshrc"
  local expected_hash expected_mode
  expected_hash="$(file_hash "$SANDBOX/.zshrc")"
  expected_mode="$(file_mode "$SANDBOX/.zshrc")"
  ln -s missing-backup-target "$SANDBOX/.zshrc.df-p10k-themes.bak"

  run df_cli init

  [ "$status" -ne 0 ]
  [[ "$output" == *"backup path exists but is not a regular file"* ]]
  [ "$expected_hash" = "$(file_hash "$SANDBOX/.zshrc")" ]
  [ "$expected_mode" = "$(file_mode "$SANDBOX/.zshrc")" ]
  [ -L "$SANDBOX/.zshrc.df-p10k-themes.bak" ]
  [ "$(readlink "$SANDBOX/.zshrc.df-p10k-themes.bak")" = missing-backup-target ]
  [ ! -e "$SANDBOX/missing-backup-target" ]
  assert_no_file_temps "$SANDBOX/.zshrc"
}

@test "init preserves a cyclic backup symlink and destination" {
  chmod 0640 "$SANDBOX/.zshrc"
  local expected_hash expected_mode
  expected_hash="$(file_hash "$SANDBOX/.zshrc")"
  expected_mode="$(file_mode "$SANDBOX/.zshrc")"
  ln -s .zshrc.df-p10k-themes.bak "$SANDBOX/.zshrc.df-p10k-themes.bak"

  run df_cli init

  [ "$status" -ne 0 ]
  [[ "$output" == *"backup path exists but is not a regular file"* ]]
  [ "$expected_hash" = "$(file_hash "$SANDBOX/.zshrc")" ]
  [ "$expected_mode" = "$(file_mode "$SANDBOX/.zshrc")" ]
  [ -L "$SANDBOX/.zshrc.df-p10k-themes.bak" ]
  [ "$(readlink "$SANDBOX/.zshrc.df-p10k-themes.bak")" = .zshrc.df-p10k-themes.bak ]
  assert_no_file_temps "$SANDBOX/.zshrc"
}

@test "init producer failure preserves zshrc bytes and mode without candidates" {
  chmod 0640 "$SANDBOX/.zshrc"
  local expected_hash expected_mode
  expected_hash="$(file_hash "$SANDBOX/.zshrc")"
  expected_mode="$(file_mode "$SANDBOX/.zshrc")"
  mkdir -p "$SANDBOX/fake-bin"
  cat >"$SANDBOX/fake-bin/cat" <<'EOF'
#!/bin/sh
if [ "$#" -eq 0 ]; then
  exec /bin/cat
fi
case "$1" in
  *.source.??????) printf 'partial init\n'; exit 71 ;;
  *) exec /bin/cat "$@" ;;
esac
EOF
  chmod 0755 "$SANDBOX/fake-bin/cat"
  export PATH="$SANDBOX/fake-bin:$PATH"

  run df_cli init

  [ "$status" -eq 71 ]
  [ "$expected_hash" = "$(file_hash "$SANDBOX/.zshrc")" ]
  [ "$expected_mode" = "$(file_mode "$SANDBOX/.zshrc")" ]
  [ ! -e "$SANDBOX/.zshrc.df-p10k-themes.bak" ]
  assert_no_file_temps "$SANDBOX/.zshrc"

  printf 'pre-existing backup\n' >"$SANDBOX/.zshrc.df-p10k-themes.bak"
  local backup_hash backup_mode
  backup_hash="$(file_hash "$SANDBOX/.zshrc.df-p10k-themes.bak")"
  backup_mode="$(file_mode "$SANDBOX/.zshrc.df-p10k-themes.bak")"

  run df_cli init

  [ "$status" -eq 71 ]
  [ "$expected_hash" = "$(file_hash "$SANDBOX/.zshrc")" ]
  [ "$expected_mode" = "$(file_mode "$SANDBOX/.zshrc")" ]
  [ "$backup_hash" = "$(file_hash "$SANDBOX/.zshrc.df-p10k-themes.bak")" ]
  [ "$backup_mode" = "$(file_mode "$SANDBOX/.zshrc.df-p10k-themes.bak")" ]
  assert_no_file_temps "$SANDBOX/.zshrc"
}

@test "init publication failure rolls back only a newly created backup" {
  chmod 0640 "$SANDBOX/.zshrc"
  local expected_hash expected_mode
  expected_hash="$(file_hash "$SANDBOX/.zshrc")"
  expected_mode="$(file_mode "$SANDBOX/.zshrc")"
  mkdir -p "$SANDBOX/fake-bin"
  cat >"$SANDBOX/fake-bin/mv" <<'EOF'
#!/bin/sh
exit 73
EOF
  chmod 0755 "$SANDBOX/fake-bin/mv"
  export PATH="$SANDBOX/fake-bin:$PATH"

  run df_cli init

  [ "$status" -eq 73 ]
  [ "$expected_hash" = "$(file_hash "$SANDBOX/.zshrc")" ]
  [ "$expected_mode" = "$(file_mode "$SANDBOX/.zshrc")" ]
  [ ! -e "$SANDBOX/.zshrc.df-p10k-themes.bak" ]
  assert_no_file_temps "$SANDBOX/.zshrc"

  printf 'pre-existing backup\n' >"$SANDBOX/.zshrc.df-p10k-themes.bak"
  local backup_hash backup_mode
  backup_hash="$(file_hash "$SANDBOX/.zshrc.df-p10k-themes.bak")"
  backup_mode="$(file_mode "$SANDBOX/.zshrc.df-p10k-themes.bak")"

  run df_cli init

  [ "$status" -eq 73 ]
  [ "$expected_hash" = "$(file_hash "$SANDBOX/.zshrc")" ]
  [ "$expected_mode" = "$(file_mode "$SANDBOX/.zshrc")" ]
  [ "$backup_hash" = "$(file_hash "$SANDBOX/.zshrc.df-p10k-themes.bak")" ]
  [ "$backup_mode" = "$(file_mode "$SANDBOX/.zshrc.df-p10k-themes.bak")" ]
  assert_no_file_temps "$SANDBOX/.zshrc"
}

@test "init TERM during publication rolls back only a newly created backup" {
  chmod 0640 "$SANDBOX/.zshrc"
  local expected_hash expected_mode
  expected_hash="$(file_hash "$SANDBOX/.zshrc")"
  expected_mode="$(file_mode "$SANDBOX/.zshrc")"
  mkdir -p "$SANDBOX/fake-bin"
  cat >"$SANDBOX/fake-bin/mv" <<'EOF'
#!/bin/sh
kill -TERM "$PPID"
sleep 1
exit 75
EOF
  chmod 0755 "$SANDBOX/fake-bin/mv"
  export PATH="$SANDBOX/fake-bin:$PATH"

  run df_cli init

  [ "$status" -ne 0 ]
  [ "$expected_hash" = "$(file_hash "$SANDBOX/.zshrc")" ]
  [ "$expected_mode" = "$(file_mode "$SANDBOX/.zshrc")" ]
  [ ! -e "$SANDBOX/.zshrc.df-p10k-themes.bak" ]
  assert_no_file_temps "$SANDBOX/.zshrc"

  printf 'pre-existing backup\n' >"$SANDBOX/.zshrc.df-p10k-themes.bak"
  local backup_hash backup_mode
  backup_hash="$(file_hash "$SANDBOX/.zshrc.df-p10k-themes.bak")"
  backup_mode="$(file_mode "$SANDBOX/.zshrc.df-p10k-themes.bak")"

  run df_cli init

  [ "$status" -ne 0 ]
  [ "$expected_hash" = "$(file_hash "$SANDBOX/.zshrc")" ]
  [ "$expected_mode" = "$(file_mode "$SANDBOX/.zshrc")" ]
  [ "$backup_hash" = "$(file_hash "$SANDBOX/.zshrc.df-p10k-themes.bak")" ]
  [ "$backup_mode" = "$(file_mode "$SANDBOX/.zshrc.df-p10k-themes.bak")" ]
  assert_no_file_temps "$SANDBOX/.zshrc"
}

@test "uninstall restores zshrc byte-identically and removes backup" {
  df_cli init >/dev/null
  df_cli apply catppuccin-mocha >/dev/null
  run df_cli uninstall
  [ "$status" -eq 0 ]
  diff -q "$SANDBOX/.zshrc" "$FIXTURES/zshrc.sample"
  [ ! -f "$SANDBOX/.zshrc.df-p10k-themes.bak" ]
  [ ! -f "$(active_file)" ]
}

@test "uninstall is a no-op when nothing is installed" {
  run df_cli uninstall
  [ "$status" -eq 0 ]
  [[ "$output" == *"nothing to remove"* ]]
}

@test "init and uninstall preserve a regular zshrc mode" {
  chmod 0640 "$SANDBOX/.zshrc"
  df_cli init >/dev/null
  [ "$(file_mode "$SANDBOX/.zshrc")" = 640 ]
  df_cli uninstall >/dev/null
  [ "$(file_mode "$SANDBOX/.zshrc")" = 640 ]
}

@test "init and uninstall preserve relative chained symlinks and target content" {
  mv "$SANDBOX/.zshrc" "$SANDBOX/zshrc.target"
  chmod 0640 "$SANDBOX/zshrc.target"
  ln -s zshrc.target "$SANDBOX/zshrc.link"
  ln -s zshrc.link "$SANDBOX/.zshrc"

  df_cli init >/dev/null
  [ -L "$SANDBOX/.zshrc" ]
  [ -L "$SANDBOX/zshrc.link" ]
  [ "$(readlink "$SANDBOX/.zshrc")" = zshrc.link ]
  [ "$(readlink "$SANDBOX/zshrc.link")" = zshrc.target ]
  [ "$(file_mode "$SANDBOX/zshrc.target")" = 640 ]
  assert_file_contains "$SANDBOX/zshrc.target" "# >>> df-p10k-themes >>>"

  df_cli uninstall >/dev/null
  [ -L "$SANDBOX/.zshrc" ]
  [ -L "$SANDBOX/zshrc.link" ]
  [ "$(readlink "$SANDBOX/.zshrc")" = zshrc.link ]
  [ "$(readlink "$SANDBOX/zshrc.link")" = zshrc.target ]
  [ "$(file_mode "$SANDBOX/zshrc.target")" = 640 ]
  cmp -s "$SANDBOX/zshrc.target" "$FIXTURES/zshrc.sample"
}

@test "uninstall preserves pre-existing trailing blank lines" {
  printf 'export EDITOR=vim\n\n\n' >"$SANDBOX/.zshrc"
  cp "$SANDBOX/.zshrc" "$SANDBOX/expected.zshrc"

  df_cli init >/dev/null
  df_cli uninstall >/dev/null

  cmp -s "$SANDBOX/.zshrc" "$SANDBOX/expected.zshrc"
}

@test "uninstall preserves edits and trailing blank lines after the hook" {
  printf 'export BEFORE_HOOK=preserve\n\n\n' >"$SANDBOX/.zshrc"
  df_cli init >/dev/null
  printf 'export AFTER_HOOK=preserve\n\n\n' >>"$SANDBOX/.zshrc"
  printf 'export BEFORE_HOOK=preserve\n\n\nexport AFTER_HOOK=preserve\n\n\n' >"$SANDBOX/expected.zshrc"

  df_cli uninstall >/dev/null

  cmp -s "$SANDBOX/.zshrc" "$SANDBOX/expected.zshrc"
  [ -f "$SANDBOX/.zshrc.df-p10k-themes.bak" ]
}

@test "fallback uninstall preserves post-hook edits without a final newline" {
  cp "$SANDBOX/.zshrc" "$SANDBOX/expected.zshrc"
  df_cli init >/dev/null
  printf 'export AFTER_HOOK_NO_NEWLINE=preserve' >>"$SANDBOX/.zshrc"
  printf 'export AFTER_HOOK_NO_NEWLINE=preserve' >>"$SANDBOX/expected.zshrc"
  local expected_hash
  expected_hash="$(file_hash "$SANDBOX/expected.zshrc")"

  df_cli uninstall >/dev/null

  [ "$expected_hash" = "$(file_hash "$SANDBOX/.zshrc")" ]
  cmp -s "$SANDBOX/.zshrc" "$SANDBOX/expected.zshrc"
  [ -f "$SANDBOX/.zshrc.df-p10k-themes.bak" ]
}

@test "fallback producer failure preserves chained zshrc links, target, and active state" {
  mv "$SANDBOX/.zshrc" "$SANDBOX/zshrc.target"
  chmod 0640 "$SANDBOX/zshrc.target"
  ln -s zshrc.target "$SANDBOX/zshrc.link"
  ln -s zshrc.link "$SANDBOX/.zshrc"
  df_cli init >/dev/null
  printf 'export AFTER_HOOK=preserve' >>"$SANDBOX/zshrc.target"
  mkdir -p "$(dirname "$(active_file)")"
  printf 'active sentinel\n' >"$(active_file)"
  local expected_hash expected_mode
  expected_hash="$(file_hash "$SANDBOX/zshrc.target")"
  expected_mode="$(file_mode "$SANDBOX/zshrc.target")"
  mkdir -p "$SANDBOX/fake-bin"
  cat >"$SANDBOX/fake-bin/awk" <<'EOF'
#!/bin/sh
case "$*" in
  *'!skip'*) printf 'partial fallback\n'; exit 72 ;;
  *) exec /usr/bin/awk "$@" ;;
esac
EOF
  chmod 0755 "$SANDBOX/fake-bin/awk"
  export PATH="$SANDBOX/fake-bin:$PATH"

  run df_cli uninstall

  [ "$status" -eq 72 ]
  [ "$expected_hash" = "$(file_hash "$SANDBOX/zshrc.target")" ]
  [ "$expected_mode" = "$(file_mode "$SANDBOX/zshrc.target")" ]
  [ "$(readlink "$SANDBOX/.zshrc")" = zshrc.link ]
  [ "$(readlink "$SANDBOX/zshrc.link")" = zshrc.target ]
  [ "$(<"$(active_file)")" = "active sentinel" ]
  assert_no_file_temps "$SANDBOX/zshrc.target"
}

@test "backup producer failure preserves zshrc bytes, mode, and active state" {
  chmod 0640 "$SANDBOX/.zshrc"
  df_cli init >/dev/null
  mkdir -p "$(dirname "$(active_file)")"
  printf 'active sentinel\n' >"$(active_file)"
  local expected_hash expected_mode
  expected_hash="$(file_hash "$SANDBOX/.zshrc")"
  expected_mode="$(file_mode "$SANDBOX/.zshrc")"
  mkdir -p "$SANDBOX/fake-bin"
  cat >"$SANDBOX/fake-bin/cat" <<'EOF'
#!/bin/sh
if [ "$#" -eq 0 ]; then
  exec /bin/cat
fi
case "$1" in
  *.df-p10k-themes.bak)
    count=0
    [ ! -f "$DF_FAKE_CAT_COUNT" ] || count=$(/bin/cat "$DF_FAKE_CAT_COUNT")
    count=$((count + 1))
    printf '%s\n' "$count" >"$DF_FAKE_CAT_COUNT"
    if [ "$count" -eq 2 ]; then
      printf 'partial backup\n'
      exit 74
    fi
    ;;
esac
exec /bin/cat "$@"
EOF
  chmod 0755 "$SANDBOX/fake-bin/cat"
  export DF_FAKE_CAT_COUNT="$SANDBOX/cat-count"
  export PATH="$SANDBOX/fake-bin:$PATH"

  run df_cli uninstall

  [ "$status" -eq 74 ]
  [ "$expected_hash" = "$(file_hash "$SANDBOX/.zshrc")" ]
  [ "$expected_mode" = "$(file_mode "$SANDBOX/.zshrc")" ]
  [ "$(<"$(active_file)")" = "active sentinel" ]
  [ -f "$SANDBOX/.zshrc.df-p10k-themes.bak" ]
  assert_no_file_temps "$SANDBOX/.zshrc"
}

@test "partial first backup read cannot authorize restoration" {
  printf 'keep\nremove-me\n' >"$SANDBOX/zshrc.target"
  chmod 0640 "$SANDBOX/zshrc.target"
  rm "$SANDBOX/.zshrc"
  ln -s zshrc.target "$SANDBOX/zshrc.link"
  ln -s zshrc.link "$SANDBOX/.zshrc"
  df_cli init >/dev/null
  /usr/bin/awk '$0 != "remove-me"' "$SANDBOX/zshrc.target" >"$SANDBOX/edited.zshrc"
  /bin/cat "$SANDBOX/edited.zshrc" >"$SANDBOX/zshrc.target"
  mkdir -p "$(dirname "$(active_file)")"
  printf 'active sentinel\n' >"$(active_file)"
  local zshrc_hash zshrc_mode backup_hash backup_mode active_hash
  zshrc_hash="$(file_hash "$SANDBOX/zshrc.target")"
  zshrc_mode="$(file_mode "$SANDBOX/zshrc.target")"
  backup_hash="$(file_hash "$SANDBOX/.zshrc.df-p10k-themes.bak")"
  backup_mode="$(file_mode "$SANDBOX/.zshrc.df-p10k-themes.bak")"
  active_hash="$(file_hash "$(active_file)")"
  mkdir -p "$SANDBOX/fake-bin"
  cat >"$SANDBOX/fake-bin/cat" <<'EOF'
#!/bin/sh
case "${1-}" in
  *.df-p10k-themes.bak)
    count=0
    [ ! -f "$DF_FAKE_CAT_COUNT" ] || count=$(/bin/cat "$DF_FAKE_CAT_COUNT")
    count=$((count + 1))
    printf '%s\n' "$count" >"$DF_FAKE_CAT_COUNT"
    if [ "$count" -eq 1 ]; then
      printf 'keep\n'
      exit 74
    fi
    ;;
esac
exec /bin/cat "$@"
EOF
  chmod 0755 "$SANDBOX/fake-bin/cat"
  export DF_FAKE_CAT_COUNT="$SANDBOX/cat-count"
  export PATH="$SANDBOX/fake-bin:$PATH"

  run df_cli uninstall

  [ "$status" -eq 74 ]
  [ "$zshrc_hash" = "$(file_hash "$SANDBOX/zshrc.target")" ]
  [ "$zshrc_mode" = "$(file_mode "$SANDBOX/zshrc.target")" ]
  [ "$backup_hash" = "$(file_hash "$SANDBOX/.zshrc.df-p10k-themes.bak")" ]
  [ "$backup_mode" = "$(file_mode "$SANDBOX/.zshrc.df-p10k-themes.bak")" ]
  [ "$active_hash" = "$(file_hash "$(active_file)")" ]
  [ "$(readlink "$SANDBOX/.zshrc")" = zshrc.link ]
  [ "$(readlink "$SANDBOX/zshrc.link")" = zshrc.target ]
  assert_no_file_temps "$SANDBOX/zshrc.target"
}

@test "final backup comparison error preserves complete recovery state" {
  mv "$SANDBOX/.zshrc" "$SANDBOX/zshrc.target"
  chmod 0640 "$SANDBOX/zshrc.target"
  ln -s zshrc.target "$SANDBOX/zshrc.link"
  ln -s zshrc.link "$SANDBOX/.zshrc"
  df_cli init >/dev/null
  df_cli apply nord >/dev/null
  local zshrc_hash zshrc_mode backup_hash backup_mode active_hash
  zshrc_hash="$(file_hash "$SANDBOX/zshrc.target")"
  zshrc_mode="$(file_mode "$SANDBOX/zshrc.target")"
  backup_hash="$(file_hash "$SANDBOX/.zshrc.df-p10k-themes.bak")"
  backup_mode="$(file_mode "$SANDBOX/.zshrc.df-p10k-themes.bak")"
  active_hash="$(file_hash "$(active_file)")"
  mkdir -p "$SANDBOX/fake-bin"
  cat >"$SANDBOX/fake-bin/cmp" <<'EOF'
#!/bin/sh
count=0
[ ! -f "$DF_CMP_COUNT" ] || count=$(/bin/cat "$DF_CMP_COUNT")
count=$((count + 1))
printf '%s\n' "$count" >"$DF_CMP_COUNT"
if [ "$count" -eq 2 ]; then
  exit 86
fi
exec /usr/bin/cmp "$@"
EOF
  chmod 0755 "$SANDBOX/fake-bin/cmp"
  export DF_CMP_COUNT="$SANDBOX/cmp-count"
  export PATH="$SANDBOX/fake-bin:$PATH"

  run df_cli uninstall

  [ "$status" -eq 86 ]
  [ "$zshrc_hash" = "$(file_hash "$SANDBOX/zshrc.target")" ]
  [ "$zshrc_mode" = "$(file_mode "$SANDBOX/zshrc.target")" ]
  [ "$backup_hash" = "$(file_hash "$SANDBOX/.zshrc.df-p10k-themes.bak")" ]
  [ "$backup_mode" = "$(file_mode "$SANDBOX/.zshrc.df-p10k-themes.bak")" ]
  [ "$active_hash" = "$(file_hash "$(active_file)")" ]
  [ "$(readlink "$SANDBOX/.zshrc")" = zshrc.link ]
  [ "$(readlink "$SANDBOX/zshrc.link")" = zshrc.target ]
  assert_no_file_temps "$SANDBOX/zshrc.target"
}

@test "uninstall restores an untouched zshrc without a final newline" {
  printf 'export EDITOR=vim' >"$SANDBOX/.zshrc"
  cp "$SANDBOX/.zshrc" "$SANDBOX/expected.zshrc"

  df_cli init >/dev/null
  df_cli uninstall >/dev/null

  cmp -s "$SANDBOX/.zshrc" "$SANDBOX/expected.zshrc"
}

@test "init rejects malformed and duplicate marker structures without mutation" {
  local open='# >>> df-p10k-themes >>>'
  local close='# <<< df-p10k-themes <<<'
  local content
  local malformed_cases=(
    "$open"
    "$close"
    "$close"$'\n'"$open"
    "$open"$'\n'"$open"$'\n'"$close"
    "$open"$'\n'"$close"$'\n'"$close"
    "$open"$'\n'"$close"$'\n'"$open"$'\n'"$close"
  )

  for content in "${malformed_cases[@]}"; do
    printf '%s\nexport USER_SETTING=preserve-me\n' "$content" >"$SANDBOX/.zshrc"
    cp "$SANDBOX/.zshrc" "$SANDBOX/expected.zshrc"
    rm -f "$SANDBOX/.zshrc.df-p10k-themes.bak"

    run df_cli init
    [ "$status" -ne 0 ]
    [[ "$output" == *"malformed or duplicate"* ]]
    cmp -s "$SANDBOX/.zshrc" "$SANDBOX/expected.zshrc"
    [ ! -e "$SANDBOX/.zshrc.df-p10k-themes.bak" ]
  done
}

@test "uninstall rejects malformed markers before removing active state" {
  local open='# >>> df-p10k-themes >>>'
  local close='# <<< df-p10k-themes <<<'
  local content
  local malformed_cases=(
    "$open"
    "$close"$'\n'"$open"
    "$open"$'\n'"$open"$'\n'"$close"
    "$open"$'\n'"$close"$'\n'"$open"$'\n'"$close"
  )
  mkdir -p "$(dirname "$(active_file)")"

  for content in "${malformed_cases[@]}"; do
    printf '%s\nexport USER_SETTING=preserve-me\n' "$content" >"$SANDBOX/.zshrc"
    cp "$SANDBOX/.zshrc" "$SANDBOX/expected.zshrc"
    printf 'active sentinel\n' >"$(active_file)"

    run df_cli uninstall
    [ "$status" -ne 0 ]
    [[ "$output" == *"malformed or duplicate"* ]]
    cmp -s "$SANDBOX/.zshrc" "$SANDBOX/expected.zshrc"
    [ "$(<"$(active_file)")" = "active sentinel" ]
  done
}

@test "broken and cyclic zshrc symlinks fail without mutation" {
  rm "$SANDBOX/.zshrc"
  ln -s missing.zshrc "$SANDBOX/.zshrc"
  mkdir -p "$(dirname "$(active_file)")"
  printf 'active sentinel\n' >"$(active_file)"

  run df_cli uninstall
  [ "$status" -ne 0 ]
  [[ "$output" == *"broken symlink"* ]]
  [ "$(readlink "$SANDBOX/.zshrc")" = missing.zshrc ]
  [ "$(<"$(active_file)")" = "active sentinel" ]
  [ ! -e "$SANDBOX/.zshrc.df-p10k-themes.bak" ]

  rm "$SANDBOX/.zshrc"
  ln -s zshrc.cycle "$SANDBOX/.zshrc"
  ln -s .zshrc "$SANDBOX/zshrc.cycle"

  run df_cli uninstall
  [ "$status" -ne 0 ]
  [[ "$output" == *"too many symlinks"* ]]
  [ "$(readlink "$SANDBOX/.zshrc")" = zshrc.cycle ]
  [ "$(readlink "$SANDBOX/zshrc.cycle")" = .zshrc ]
  [ "$(<"$(active_file)")" = "active sentinel" ]
  [ ! -e "$SANDBOX/.zshrc.df-p10k-themes.bak" ]
}

@test "the complete lifecycle never changes p10k.zsh" {
  printf 'p10k sentinel: preserve exactly\n\n' >"$SANDBOX/.p10k.zsh"
  cp "$SANDBOX/.p10k.zsh" "$SANDBOX/expected.p10k.zsh"

  df_cli init >/dev/null
  df_cli apply tokyo-night blue >/dev/null
  df_cli uninstall >/dev/null

  cmp -s "$SANDBOX/.p10k.zsh" "$SANDBOX/expected.p10k.zsh"
}
