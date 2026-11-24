#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
GODOT_DIR="$ROOT/godot"
DIST_DIR="$ROOT/dist"
GODOT_BIN="${GODOT_BIN:-}"

if [[ -z "$GODOT_BIN" ]]; then
  if command -v godot >/dev/null 2>&1; then
    GODOT_BIN="$(command -v godot)"
  elif command -v godot4 >/dev/null 2>&1; then
    GODOT_BIN="$(command -v godot4)"
  else
    echo "Godot 4.7.x not found. Install it with: sudo pacman -S godot" >&2
    exit 1
  fi
fi

VERSION="$("$GODOT_BIN" --version | head -n1)"
if [[ "$VERSION" != 4.7* ]]; then
  echo "This project targets Godot 4.7.x; found: $VERSION" >&2
  echo "Set GODOT_BIN=/path/to/Godot_v4.7.x to choose another binary." >&2
  exit 1
fi

mkdir -p "$DIST_DIR"
echo "Checking/importing project with $VERSION..."
"$GODOT_BIN" --headless --path "$GODOT_DIR" --editor --quit

echo "Exporting standalone Linux x86_64 game..."
"$GODOT_BIN" --headless --path "$GODOT_DIR" --export-release "Linux/X11" "$DIST_DIR/NEON-COAST.x86_64"
chmod +x "$DIST_DIR/NEON-COAST.x86_64"

echo "Building Arch package..."
cp "$ROOT/packaging/arch/PKGBUILD" "$DIST_DIR/PKGBUILD"
cp "$ROOT/packaging/arch/neon-coast.desktop" "$DIST_DIR/"
cp "$ROOT/packaging/arch/neon-coast.svg" "$DIST_DIR/"
cp "$ROOT/packaging/arch/neon-coast" "$DIST_DIR/"
chmod +x "$DIST_DIR/neon-coast"
cd "$DIST_DIR"
makepkg --cleanbuild --force

echo
echo "Build complete. Package:"
ls -1 "$DIST_DIR"/neon-coast-*.pkg.tar.zst
