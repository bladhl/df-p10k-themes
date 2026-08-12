#!/usr/bin/env bash
set -euo pipefail

PREFIX="${PREFIX:-$HOME/.local}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd "$SCRIPT_DIR"
make install PREFIX="$PREFIX"

printf '\n\xe2\x9c\x93 installed to %s/bin/df-p10k-themes\n' "$PREFIX"
# $PATH stays literal below — that line is copied into the user's shell rc.
# shellcheck disable=SC2016
case ":$PATH:" in
  *":$PREFIX/bin:"*) ;;
  *) printf '\nadd this to your shell rc:\n  export PATH="%s/bin:$PATH"\n' "$PREFIX" ;;
esac

printf '\nnext step:\n  df-p10k-themes init\n  df-p10k-themes apply catppuccin-mocha\n'
