#!/usr/bin/env bash
set -euo pipefail
candidate=$(cd "$(dirname "$1")" && pwd)/$(basename "$1")
baseline=$(cd "$(dirname "$2")" && pwd)/$(basename "$2")
brew tap euforicio/taps "$PWD"
tap=$(brew --repo euforicio/taps)
if brew help trust >/dev/null 2>&1; then
  brew trust --formula euforicio/taps/dotlocal
fi
cp "$baseline" "$tap/Formula/dotlocal.rb"
brew install euforicio/taps/dotlocal
brew test euforicio/taps/dotlocal
before=$(brew list --versions dotlocal)
cp "$candidate" "$tap/Formula/dotlocal.rb"
brew upgrade euforicio/taps/dotlocal
brew test euforicio/taps/dotlocal
brew audit --strict euforicio/taps/dotlocal
brew style euforicio/taps/dotlocal
after=$(brew list --versions dotlocal)
printf 'Brew install/upgrade: %s -> %s\n' "$before" "$after"
bin="$(brew --prefix dotlocal)/bin/dotlocal"
bundle="$(brew --prefix dotlocal)/libexec/dotlocal"
test_home=$(mktemp -d /tmp/dlb.XXXXXX)
test_home=$(cd "$test_home" && pwd -P)
trap 'rm -rf "$test_home"' EXIT
export HOME="$test_home"
version=$(sed -n 's|.*releases/download/v\([0-9.]*\)/.*|\1|p' "$candidate" | head -n 1)
previous=$(sed -n 's|.*releases/download/v\([0-9.]*\)/.*|\1|p' "$baseline" | head -n 1)
test "$("$bin" version)" = "$version"
if [ -f "$bundle" ]; then
  checksum=$(shasum -a 256 "$bundle")
  "$bin" update --check
  "$bin" update --version "$previous"
  test "$("$bin" version)" = "$previous"
  "$bin" config unset pin
  # An unpinned older runtime advances to the newer authenticated Brew bundle.
  test "$("$bin" version)" = "$version"
  "$bin" update --version "$previous"
  # The immutable bundle is already newer; the launch still honors the pin.
  test "$("$bin" version)" = "$previous"
  "$bin" update
  test "$("$bin" version)" = "$version"
  test "$(shasum -a 256 "$bundle")" = "$checksum"
  printf 'PASS signed CLI update, Brew catch-up, pin and immutable Brew bundle\n'
fi
python3 scripts/test-route.py "$bin"
