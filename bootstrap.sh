#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v brew >/dev/null 2>&1; then
  printf 'Homebrew is required. Install it from https://brew.sh/ and rerun this script.\n' >&2
  exit 1
fi

brew bundle --file "$repo_dir/packages/bundle"

printf 'Checking links from home/ to %s\n' "$HOME"
stow --simulate --verbose --no-folding --dir "$repo_dir" --target "$HOME" home

printf 'Linking home/ to %s\n' "$HOME"
stow --restow --verbose --no-folding --dir "$repo_dir" --target "$HOME" home
