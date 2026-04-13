#!/bin/sh
# Build extension toolbar/store PNGs under icons/ from images/STOP.png, then Mac host AppIcon assets.
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$ROOT/images/STOP.png"
if [ ! -f "$SRC" ]; then
  echo "Missing source image: $SRC" >&2
  exit 1
fi

mkdir -p "$ROOT/icons"
# Sizes referenced by manifest.json (and common store / toolbar needs)
for pair in 16:icon16.png 32:icon32.png 48:icon48.png 96:icon96.png 128:icon128.png; do
  size="${pair%%:*}"
  name="${pair#*:}"
  sips -z "$size" "$size" "$SRC" --out "$ROOT/icons/$name" >/dev/null
done

sh "$ROOT/safari/scripts/generate-mac-app-icons.sh"
echo "Wrote icons/icon{16,32,48,96,128}.png and safari Host AppIcon assets from images/STOP.png"
