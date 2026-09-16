#!/usr/bin/env bash
set -euo pipefail

PREFIX="${PREFIX:-$HOME/.local}"
REPO="https://github.com/bladhl/df-p10k-themes"
SRC="$(cd "$(dirname "${BASH_SOURCE[0]:-.}")" && pwd)"

# Piped through curl (no script file, so never trust the cwd) or run outside a
# checkout: fetch the main tarball.
if [ -z "${BASH_SOURCE[0]:-}" ] || [ ! -f "$SRC/bin/df-p10k-themes" ]; then
  SRC="$(mktemp -d)"
  trap 'rm -rf "$SRC"' EXIT
  curl -fsSL "$REPO/archive/refs/heads/main.tar.gz" \
    | tar -xzf - -C "$SRC" --strip-components=1
fi

make -C "$SRC" install PREFIX="$PREFIX"

printf '\n\xe2\x9c\x93 installed to %s/bin/df-p10k-themes\n' "$PREFIX"
# $PATH stays literal below — that line is copied into the user's shell rc.
# shellcheck disable=SC2016
case ":$PATH:" in
  *":$PREFIX/bin:"*) ;;
  *) printf '\nadd this to your shell rc:\n  export PATH="%s/bin:$PATH"\n' "$PREFIX" ;;
esac

printf '\nnext step:\n  df-p10k-themes init\n  df-p10k-themes apply catppuccin-mocha\n'
